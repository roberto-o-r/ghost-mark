import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_mark/features/feedback/feedback.dart';
import 'package:ghost_mark/features/editor/presentation/main_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('feedback link includes only app name and form presentation flag', () {
    expect(feedbackUri().queryParameters,
        {'usp': 'pp_url', 'entry.2007142099': 'GhostMark'});
    expect(feedbackUri().scheme, 'https');
    expect(ratingUri(TargetPlatform.android)!.queryParameters['id'],
        'com.eunoia.ghost_mark');
    expect(ratingUri(TargetPlatform.iOS, appStoreId: ''), isNull);
    expect(ratingUri(TargetPlatform.iOS, appStoreId: '123')!.host,
        'apps.apple.com');
  });
  test('invitation waits fourteen calendar days and first use survives restart',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    var now = DateTime(2026, 10, 25, 23, 59);
    final c = FeedbackController(prefs, clock: () => now);
    await c.initialize();
    expect(c.showPrompt, isFalse);
    now = DateTime(2026, 11, 7, 23, 59);
    expect(c.showPrompt, isFalse);
    now = DateTime(2026, 11, 8);
    expect(c.showPrompt, isTrue);
    final restarted = FeedbackController(prefs, clock: () => now);
    await restarted.initialize();
    expect(restarted.showPrompt, isTrue);
    await restarted.dismiss();
    final dismissed = FeedbackController(prefs,
        clock: () => now.add(const Duration(days: 50)));
    await dismissed.initialize();
    expect(dismissed.showPrompt, isFalse);
    c.dispose();
    restarted.dispose();
    dismissed.dispose();
  });
  test(
      'failed handoff retains invitation; successful handoff persists dismissal',
      () async {
    SharedPreferences.setMockInitialValues(
        {FeedbackController.firstUseKey: '2026-10-01'});
    final prefs = await SharedPreferences.getInstance();
    var succeeds = false;
    Uri? received;
    final c = FeedbackController(prefs,
        clock: () => DateTime(2026, 11, 19),
        open: (uri) async {
          received = uri;
          return succeeds;
        });
    await c.initialize();
    await expectLater(c.open(feedbackUri()), throwsStateError);
    expect(c.showPrompt, isTrue);
    succeeds = true;
    await c.open(feedbackUri());
    expect(received, feedbackUri());
    expect(c.showPrompt, isFalse);
    expect(prefs.getBool(FeedbackController.dismissedKey), isTrue);
    c.dispose();
  });
  testWidgets('menu works on both tabs; invitation dismisses at narrow width',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues(
        {FeedbackController.firstUseKey: '2026-10-01'});
    final prefs = await SharedPreferences.getInstance();
    Uri? opened;
    final c = FeedbackController(prefs,
        clock: () => DateTime(2026, 11, 19),
        open: (uri) async {
          opened = uri;
          return true;
        });
    await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: MainScreen(feedback: c))));
    await tester.pumpAndSettle();
    expect(find.text('Help shape GhostMark'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Dismiss feedback invitation'));
    await tester.pumpAndSettle();
    expect(find.text('Help shape GhostMark'), findsNothing);
    for (final label in ['Edit', 'View']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('More options'));
      await tester.pumpAndSettle();
      expect(find.text('Rate GhostMark'), findsOneWidget);
      expect(find.text('Privacy policy'), findsOneWidget);
      await tester.tap(find.text('Share feedback'));
      await tester.pumpAndSettle();
      expect(opened, feedbackUri());
    }
    await tester.pumpWidget(const SizedBox());
    c.dispose();
  });
  testWidgets('invitation hides with keyboard and fits large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    SharedPreferences.setMockInitialValues(
        {FeedbackController.firstUseKey: '2026-10-01'});
    final c = FeedbackController(await SharedPreferences.getInstance(),
        clock: () => DateTime(2026, 11, 19));
    await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: child!),
            home: MainScreen(feedback: c))));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    await tester.pumpAndSettle();
    expect(find.text('Help shape GhostMark'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    c.dispose();
  });
  test('privacy handoff leaves feedback invitation eligible', () async {
    SharedPreferences.setMockInitialValues(
        {FeedbackController.firstUseKey: '2026-10-01'});
    final prefs = await SharedPreferences.getInstance();
    Uri? opened;
    final c = FeedbackController(prefs,
        clock: () => DateTime(2026, 11, 19),
        open: (uri) async {
          opened = uri;
          return true;
        });
    await c.initialize();
    await c.open(privacyUri(), dismissInvitation: false);
    expect(opened.toString(), 'https://eunoialab.io/privacy/ghostmark');
    expect(c.showPrompt, isTrue);
    expect(prefs.getBool(FeedbackController.dismissedKey), isNot(true));
    c.dispose();
  });
}
