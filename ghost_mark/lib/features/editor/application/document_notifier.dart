import 'dart:convert';

import 'package:ghost_mark/features/editor/data/document.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'document_notifier.g.dart';

const String documentPrefsKey = 'document';

@riverpod
class DocumentNotifier extends _$DocumentNotifier {
  @override
  Future<Document> build() async {
    final prefs = await SharedPreferences.getInstance();
    final String? documentJson = prefs.getString(documentPrefsKey);

    if (documentJson == null) {
      return Document(content: '');
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
