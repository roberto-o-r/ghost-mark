import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_mark/features/editor/data/markdown_codec.dart';

void main() {
  const sample = '# Café — naïve ✍️ 🚀\n\n- ñandú, 日本語';

  test('encode produces UTF-8 bytes', () {
    expect(encodeMarkdown(sample), utf8.encode(sample));
  });

  test('round trip preserves non-ASCII text', () {
    expect(decodeMarkdown(encodeMarkdown(sample)), sample);
  });

  test('decode strips a UTF-8 byte order mark', () {
    final bytes = Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode('hi')]);
    expect(decodeMarkdown(bytes), 'hi');
  });

  test('decode throws FormatException for invalid UTF-8', () {
    // Bytes the previous Save implementation produced for 'Café'.
    final bytes = Uint8List.fromList('Café'.codeUnits);
    expect(() => decodeMarkdown(bytes), throwsFormatException);
  });
}
