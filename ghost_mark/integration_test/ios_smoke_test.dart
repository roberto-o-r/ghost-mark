import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ghost_mark/main.dart';
import 'package:ghost_mark/features/editor/application/document_notifier.dart';
import 'package:ghost_mark/features/feedback/feedback.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native preferences, editing, formatting, preview and capture',
      (tester) async {
    // Runs only in the isolated simulator app, never on an existing user document.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(documentPrefsKey);
    await prefs.remove(FeedbackController.firstUseKey);
    await prefs.remove(FeedbackController.dismissedKey);
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        starterDocumentContent);
    const sample =
        '# A quieter writing space\n\nCapture an idea, draft a note, or plan your next project.\n\n## Today\n\n- Write with **one-tap formatting**\n- Keep notes private and offline\n- [ ] Review the first draft\n- [ ] Save a Markdown copy\n\nUse [heading links](#today) to find your way.\n\n`Your words, your files.`';
    await tester.enterText(find.byType(TextField), sample);
    await tester.pumpAndSettle();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('01-editor');
    expect(jsonDecode(prefs.getString(documentPrefsKey)!)['content'], sample);
    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    expect(find.textContaining('A quieter writing space'), findsWidgets);
    await binding.takeScreenshot('02-preview');
    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    expect(find.text('Share feedback'), findsOneWidget);
    expect(find.text('Rate GhostMark'), findsOneWidget);
    expect(find.text('Privacy policy'), findsOneWidget);
    await binding.takeScreenshot('03-feedback-menu');
    await tester.tapAt(const Offset(10, 200));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        sample);
    await prefs.setString(FeedbackController.firstUseKey,
        DateTime.now().subtract(const Duration(days: 15)).toIso8601String());
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();
    expect(find.text('Help shape GhostMark'), findsOneWidget);
    await tester.tap(find.byTooltip('Dismiss feedback invitation'));
    await tester.pumpAndSettle();
    expect(prefs.getBool(FeedbackController.dismissedKey), isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
