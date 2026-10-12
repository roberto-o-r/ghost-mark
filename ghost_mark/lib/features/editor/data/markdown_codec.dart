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
