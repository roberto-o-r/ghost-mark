import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:ghost_mark/features/editor/application/document_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreviewScreen extends HookConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentNotifierProvider);
    final content = useState('');
    content.value = document.value?.content ?? '';

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
              child: Markdown(data: content.value),
            ),
          ),
        ],
      ),
    );
  }
}
