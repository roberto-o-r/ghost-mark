import 'dart:convert';

import 'package:ghost_mark/features/editor/data/document.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'document_notifier.g.dart';

const String documentPrefsKey = 'document';

const String starterDocumentContent =
    '# Welcome to GhostMark\n\n'
    'Replace this sample with your own words—your work is saved automatically.\n\n'
    '- Use the toolbar to **format text**\n'
    '- Tap **View** to preview your document\n'
    '- [ ] Turn ideas into checklists\n'
    '- Add [links](#quick-tips) and `code`\n\n'
    '## Quick tips\n\n'
    'Use **Open**, **Save**, and **Clear** at the top whenever you need them.';

@riverpod
class DocumentNotifier extends _$DocumentNotifier {
  @override
  Future<Document> build() async {
    final prefs = await SharedPreferences.getInstance();
    final String? documentJson = prefs.getString(documentPrefsKey);

    if (documentJson == null) {
      return Document(content: starterDocumentContent);
    }

    return Document.fromJson(jsonDecode(documentJson));
  }

  Future<void> updateDocument(Document document) async {
    final prefs = await SharedPreferences.getInstance();
    final String documentJson = jsonEncode(document.toJson());
    prefs.setString(documentPrefsKey, documentJson);

    state = AsyncData(Document.fromJson(jsonDecode(documentJson)));
  }
}
