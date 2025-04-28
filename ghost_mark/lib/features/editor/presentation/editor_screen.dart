import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ghost_mark/features/editor/application/document_notifier.dart';
import 'package:ghost_mark/features/editor/data/document.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditorScreen extends HookConsumerWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentNotifierProvider);
    final contentController = useTextEditingController();
    contentController.text = document.value?.content ?? '';

    useEffect(() {
      final updateDocument = ref.watch(documentNotifierProvider.notifier).updateDocument;
      return () {
        updateDocument(
          Document(content: contentController.text),
        );
      };
    }, []);

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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
