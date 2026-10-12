import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_mark/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeFilePicker extends FilePicker {
  String? pickedPath;
  Uint8List? savedBytes;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    final path = pickedPath;
    if (path == null) return null;
    return FilePickerResult([
      PlatformFile(path: path, name: 'picked.md', size: File(path).lengthSync()),
    ]);
  }

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async {
    savedBytes = bytes;
    return '/saved.md';
  }
}

const sample = '# Café — naïve ✍️ 🚀';

void main() {
  late FakeFilePicker picker;
  late Directory tempDir;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    picker = FakeFilePicker();
    FilePicker.platform = picker;
    tempDir = Directory.systemTemp.createTempSync('ghost_mark_test');
  });

  tearDown(() => tempDir.deleteSync(recursive: true));

  String writeFile(List<int> bytes) {
    final file = File('${tempDir.path}/doc.md')..writeAsBytesSync(bytes);
    return file.path;
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();
  }

  // Open reads the file with real I/O, so the tap must run outside fake async.
  Future<void> tapOpen(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.tap(find.byTooltip('Open'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
  }

  String editorText(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).controller!.text;

  testWidgets('Save writes non-ASCII text as UTF-8', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byType(TextField), sample);

    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(utf8.decode(picker.savedBytes!), sample);
    expect(find.text('File saved successfully!'), findsOneWidget);
  });

  testWidgets('Open into an empty editor loads non-ASCII text', (tester) async {
    picker.pickedPath = writeFile(utf8.encode(sample));
    await pumpApp(tester);

    await tapOpen(tester);

    expect(find.text('Replace Document'), findsNothing);
    expect(editorText(tester), sample);
  });

  testWidgets('Open shows an error for a file that is not UTF-8',
      (tester) async {
    picker.pickedPath = writeFile('Café'.codeUnits);
    await pumpApp(tester);

    await tapOpen(tester);

    expect(find.text('Could not open file: not UTF-8 text.'), findsOneWidget);
    expect(editorText(tester), isEmpty);
  });

  testWidgets('Open asks before replacing existing text', (tester) async {
    picker.pickedPath = writeFile(utf8.encode(sample));
    await pumpApp(tester);
    await tester.enterText(find.byType(TextField), 'draft');

    await tapOpen(tester);
    expect(find.text('Replace Document'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(editorText(tester), 'draft');

    await tapOpen(tester);
    await tester.runAsync(() async {
      await tester.tap(find.text('Replace'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
    expect(editorText(tester), sample);
  });
}
