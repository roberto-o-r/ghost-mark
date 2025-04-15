import 'package:ghost_mark/features/editor/data/document.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_notifier.g.dart';

@riverpod
class DocumentNotifier extends _$DocumentNotifier{
  @override
  Document build() {
    return Document(content: '');
  }

  void updateDocument(String newText) {
  }
}
