import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ghost_mark/features/editor/application/document_notifier.dart';
import 'package:ghost_mark/features/editor/data/document.dart';
import 'package:ghost_mark/features/editor/data/markdown_codec.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef FileAction = void Function(BuildContext context);

class EditorScreen extends HookConsumerWidget {
  static FileAction? openFileAction;
  static FileAction? saveFileAction;
  static FileAction? clearFileAction;
  final void Function(FileAction fn)? provideOpen;
  final void Function(FileAction fn)? provideSave;
  final void Function(FileAction fn)? provideClear;

  const EditorScreen(
      {super.key, this.provideOpen, this.provideSave, this.provideClear});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentNotifierProvider);
    final contentController = useTextEditingController();

    useEffect(() {
      if (document.value != null && contentController.text.isEmpty) {
        contentController.text = document.value?.content ?? '';
      }
      return null;
    }, [document.value?.content]);

    Future<bool> confirmReplace(BuildContext context) async {
      if (contentController.text.isEmpty) return true;
      final shouldReplace = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Replace Document'),
          content: const Text(
              'Opening this file will replace the current document. This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Replace'),
            ),
          ],
        ),
      );
      return shouldReplace == true;
    }

    Future<void> openFile(BuildContext context) async {
      final messenger = ScaffoldMessenger.of(context);
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['md']);
      final path = result?.files.single.path;
      if (path == null) return;

      final String content;
      try {
        content = decodeMarkdown(await File(path).readAsBytes());
      } on FormatException {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not open file: not UTF-8 text.')),
        );
        return;
      } on FileSystemException {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not read file.')),
        );
        return;
      }

      if (!context.mounted || !await confirmReplace(context)) return;
      contentController.text = content;
      ref
          .read(documentNotifierProvider.notifier)
          .updateDocument(Document(content: content));
    }

    Future<void> saveFile(BuildContext context) async {
      final messenger = ScaffoldMessenger.of(context);
      final result = await FilePicker.platform.saveFile(
        bytes: encodeMarkdown(contentController.text),
        allowedExtensions: ['md'],
      );

      if (result != null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('File saved successfully!')),
        );
      }
    }

    Future<void> clearFile(BuildContext context) async {
      final shouldClear = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Clear Editor'),
          content: const Text(
              'Are you sure you want to clear the editor? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Clear'),
            ),
          ],
        ),
      );
      if (shouldClear == true && context.mounted) {
        contentController.clear();
        ref.read(documentNotifierProvider.notifier).updateDocument(
              Document(content: ''),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Editor cleared.')),
        );
      }
    }

    // Provide the open/save actions to the parent
    provideOpen?.call(openFile);
    provideSave?.call(saveFile);
    provideClear?.call(clearFile);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: contentController,
                onChanged: (value) {
                  ref.read(documentNotifierProvider.notifier).updateDocument(
                        Document(content: value),
                      );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
