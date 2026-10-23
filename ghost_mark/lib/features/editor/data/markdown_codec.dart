import 'dart:convert';
import 'dart:typed_data';

const _byteOrderMark = '﻿';

/// Encodes Markdown text as UTF-8 bytes for saving to a file.
Uint8List encodeMarkdown(String content) => utf8.encode(content);

/// Decodes UTF-8 file bytes into Markdown text, ignoring a leading BOM.
///
/// Throws a [FormatException] if [bytes] are not valid UTF-8.
String decodeMarkdown(Uint8List bytes) {
  final content = utf8.decode(bytes);
  return content.startsWith(_byteOrderMark) ? content.substring(1) : content;
}

/// Suggested name for a saved file, unique to the second.
///
/// Android's save dialog renames a duplicate `x.md` to `x.md (1)`, which drops
/// the `.md` extension, so a fixed name can't be reused.
String defaultSaveFileName(DateTime now) {
  String two(int n) => n.toString().padLeft(2, '0');
  return 'ghostmark-${now.year}-${two(now.month)}-${two(now.day)}-'
      '${two(now.hour)}${two(now.minute)}${two(now.second)}.md';
}
