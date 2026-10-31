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
  FileType? pickedType;
  List<String>? pickedAllowedExtensions;
  Uint8List? savedBytes;
  String? savedFileName;

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
    pickedType = type;
    pickedAllowedExtensions = allowedExtensions;
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
    savedFileName = fileName;
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

  String writeFile(List<int> bytes, {String name = 'doc.md'}) {
    final file = File('${tempDir.path}/$name')..writeAsBytesSync(bytes);
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

  testWidgets('Save suggests a timestamped .md file name', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byType(TextField), sample);

    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(picker.savedFileName, matches(RegExp(r'^ghostmark-[\d-]+\.md$')));
  });

  testWidgets('Open into an empty editor loads non-ASCII text', (tester) async {
    picker.pickedPath = writeFile(utf8.encode(sample));
    await pumpApp(tester);

    await tapOpen(tester);

    expect(find.text('Replace Document'), findsNothing);
    expect(editorText(tester), sample);
  });

  for (final fileName in ['null.plain', 'notes.txt', 'README']) {
    testWidgets('Open loads UTF-8 text from $fileName', (tester) async {
      picker.pickedPath = writeFile(utf8.encode(sample), name: fileName);
      await pumpApp(tester);

      await tapOpen(tester);

      expect(picker.pickedType, FileType.any);
      expect(picker.pickedAllowedExtensions, isNull);
      expect(editorText(tester), sample);
    });
  }

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

  group('formatting toolbar', () {
    TextEditingController controller(WidgetTester tester) =>
        tester.widget<TextField>(find.byType(TextField)).controller!;

    testWidgets('Bold wraps the selection and autosaves', (tester) async {
      await pumpApp(tester);
      await tester.enterText(find.byType(TextField), 'say hi');
      controller(tester).selection =
          const TextSelection(baseOffset: 4, extentOffset: 6);

      await tester.tap(find.byTooltip('Bold'));
      await tester.pumpAndSettle();

      expect(editorText(tester), 'say **hi**');
      final prefs = await SharedPreferences.getInstance();
      expect(jsonDecode(prefs.getString('document')!)['content'],
          'say **hi**');
    });

    testWidgets('keeps the editor focused so typing continues',
        (tester) async {
      await pumpApp(tester);
      await tester.enterText(find.byType(TextField), 'Title');

      await tester.tap(find.byTooltip('Heading'));
      await tester.pumpAndSettle();

      expect(editorText(tester), '# Title');
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode!.hasFocus, isTrue);
      expect(controller(tester).selection.baseOffset, '# Title'.length);
    });

    testWidgets('formats at the end when the editor was never focused',
        (tester) async {
      await pumpApp(tester);

      await tester.tap(find.byTooltip('Checklist'));
      await tester.pumpAndSettle();

      expect(editorText(tester), '- [ ] ');
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode!.hasFocus, isTrue);
    });

    testWidgets('is not shown on the View tab', (tester) async {
      await pumpApp(tester);
      expect(find.byTooltip('Bold'), findsOneWidget);

      await tester.tap(find.text('View'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Bold'), findsNothing);
    });
  });
}
