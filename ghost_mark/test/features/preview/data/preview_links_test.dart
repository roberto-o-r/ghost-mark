import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_mark/features/preview/data/preview_links.dart';

void main() {
  group('externalWebUri', () {
    test('accepts HTTP and HTTPS links', () {
      expect(
        externalWebUri('https://example.com/a'),
        Uri.parse('https://example.com/a'),
      );
      expect(
        externalWebUri('http://example.com'),
        Uri.parse('http://example.com'),
      );
    });

    test('rejects relative and unsupported links', () {
      expect(externalWebUri('/relative'), isNull);
      expect(externalWebUri('mailto:test@example.com'), isNull);
      expect(externalWebUri('javascript:alert(1)'), isNull);
      expect(externalWebUri(null), isNull);
    });
  });

  test('internalAnchorId normalizes a fragment', () {
    expect(internalAnchorId('#Hello-World'), 'hello-world');
    expect(internalAnchorId('#hello%20world'), 'hello world');
    expect(internalAnchorId('https://example.com/#hello'), isNull);
    expect(internalAnchorId('#'), isNull);
  });

  test('UniqueHeadingIds suffixes duplicate headings', () {
    final ids = UniqueHeadingIds();
    expect(ids.next('section'), 'section');
    expect(ids.next('section'), 'section-2');
    expect(ids.next('section'), 'section-3');
    expect(ids.next('other'), 'other');
  });
}
