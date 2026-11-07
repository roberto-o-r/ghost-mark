import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_mark/features/preview/presentation/navigable_markdown.dart';

Widget _app(Widget child) => MaterialApp(
      home: Scaffold(body: SizedBox(height: 240, child: child)),
    );

Iterable<TextSpan> _textSpans(InlineSpan span) sync* {
  if (span is! TextSpan) return;
  yield span;
  for (final child in span.children ?? const <InlineSpan>[]) {
    yield* _textSpans(child);
  }
}

void main() {
  testWidgets('preview is selectable', (tester) async {
    await tester.pumpWidget(_app(const NavigableMarkdown(data: '# Select me')));

    expect(find.byType(SelectionArea), findsOneWidget);
    expect(find.text('Select me'), findsOneWidget);
  });

  testWidgets('preserves inline formatting inside headings', (tester) async {
    await tester.pumpWidget(
      _app(const NavigableMarkdown(data: '# Heading with **bold** text')),
    );

    final spans = tester.widgetList<Text>(find.byType(Text)).expand(
          (widget) => widget.textSpan == null
              ? const <TextSpan>[]
              : _textSpans(widget.textSpan!),
        );

    expect(
      spans.any(
        (span) =>
            span.text == 'bold' && span.style?.fontWeight == FontWeight.bold,
      ),
      isTrue,
    );
  });

  testWidgets('launches a safe external web link', (tester) async {
    Uri? launched;
    await tester.pumpWidget(
      _app(
        NavigableMarkdown(
          data: '[Website](https://example.com/docs)',
          launchExternalLink: (uri) async {
            launched = uri;
            return true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Website'));
    await tester.pump();

    expect(launched, Uri.parse('https://example.com/docs'));
  });

  testWidgets('rejects unsupported link schemes', (tester) async {
    var launchCalls = 0;
    await tester.pumpWidget(
      _app(
        NavigableMarkdown(
          data: '[Unsafe](javascript:alert(1))',
          launchExternalLink: (uri) async {
            launchCalls++;
            return true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Unsafe'));
    await tester.pump();

    expect(launchCalls, 0);
    expect(find.text('Only web links are supported.'), findsOneWidget);
  });

  testWidgets('scrolls to an internal heading anchor', (tester) async {
    final controller = ScrollController();
    final filler = List.generate(
      30,
      (index) => 'Paragraph $index',
    ).join('\n\n');
    await tester.pumpWidget(
      _app(
        NavigableMarkdown(
          controller: controller,
          data: '[Jump](#destination)\n\n$filler\n\n# Destination',
        ),
      ),
    );

    expect(controller.offset, 0);
    await tester.tap(find.text('Jump'));
    await tester.pumpAndSettle();

    expect(controller.offset, greaterThan(0));
  });

  testWidgets('supports duplicate heading IDs', (tester) async {
    final controller = ScrollController();
    final filler = List.generate(25, (index) => 'Line $index').join('\n\n');
    await tester.pumpWidget(
      _app(
        NavigableMarkdown(
          controller: controller,
          data: '[Second](#section-2)\n\n# Section\n\n$filler\n\n# Section',
        ),
      ),
    );

    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();

    expect(controller.offset, greaterThan(0));
  });
}
