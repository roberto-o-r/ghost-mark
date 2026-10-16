import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_mark/features/editor/data/markdown_formatting.dart';

/// A value with [text] selected from [start] to [end] (a cursor if omitted).
TextEditingValue value(String text, int start, [int? end]) => TextEditingValue(
      text: text,
      selection: TextSelection(baseOffset: start, extentOffset: end ?? start),
    );

void expectValue(TextEditingValue actual, String text, int start, [int? end]) {
  expect(actual.text, text);
  expect(actual.selection.start, start);
  expect(actual.selection.end, end ?? start);
}

void main() {
  group('toggleWrap', () {
    test('wraps the selection and keeps it selected', () {
      final result = toggleWrap(value('say hi now', 4, 6), '**');
      expectValue(result, 'say **hi** now', 6, 8);
    });

    test('inserts a pair with the cursor between when nothing is selected',
        () {
      final result = toggleWrap(value('ab', 1), '*');
      expectValue(result, 'a**b', 2);
    });

    test('removes markers that already surround the selection', () {
      final result = toggleWrap(value('say **hi** now', 6, 8), '**');
      expectValue(result, 'say hi now', 4, 6);
    });

    test('tapping twice with nothing selected removes the empty pair', () {
      final once = toggleWrap(value('', 0), '`');
      expectValue(once, '``', 1);
      expectValue(toggleWrap(once, '`'), '', 0);
    });

    test('preserves non-ASCII text', () {
      final result = toggleWrap(value('café ✍️', 0, 4), '*');
      expectValue(result, '*café* ✍️', 1, 5);
    });

    test('uses the end of the text when there is no selection', () {
      const noSelection = TextEditingValue(text: 'ab');
      expectValue(toggleWrap(noSelection, '**'), 'ab****', 4);
    });
  });

  group('insertLink', () {
    test('wraps the selection and selects the url placeholder', () {
      final result = insertLink(value('see docs', 4, 8));
      expectValue(result, 'see [docs](url)', 11, 14);
    });

    test('puts the cursor inside the brackets when nothing is selected', () {
      final result = insertLink(value('see ', 4));
      expectValue(result, 'see [](url)', 5);
    });
  });

  group('toggleLinePrefix', () {
    test('adds a prefix to the current line and moves the cursor with it', () {
      final result = toggleLinePrefix(value('one\ntwo', 5), bulletPrefix);
      expectValue(result, 'one\n- two', 7);
    });

    test('removes the prefix when the line already has it', () {
      final result = toggleLinePrefix(value('one\n- two', 7), bulletPrefix);
      expectValue(result, 'one\ntwo', 5);
    });

    test('applies to every line in the selection', () {
      final result =
          toggleLinePrefix(value('a\nb\nc', 0, 3), bulletPrefix); // a..b
      expectValue(result, '- a\n- b\nc', 2, 7);
    });

    test('adds to all lines if only some have the prefix', () {
      final result = toggleLinePrefix(value('- a\nb', 0, 5), bulletPrefix);
      expectValue(result, '- a\n- b', 0, 7);
    });

    test('replaces a different list prefix instead of stacking', () {
      final toChecklist =
          toggleLinePrefix(value('- task', 6), checklistPrefix);
      expectValue(toChecklist, '- [ ] task', 10);

      final toBullet = toggleLinePrefix(value('- [x] done', 10), bulletPrefix);
      expectValue(toBullet, '- done', 6);
    });

    test('turns a deeper heading into a level 1 heading', () {
      final result = toggleLinePrefix(value('### Title', 9), headingPrefix);
      expectValue(result, '# Title', 7);
    });

    test('a cursor inside the old prefix lands after the new one', () {
      final result = toggleLinePrefix(value('- [ ] x', 2), bulletPrefix);
      expectValue(result, '- x', 2);
    });

    test('works on an empty document', () {
      final result = toggleLinePrefix(value('', 0), headingPrefix);
      expectValue(result, '# ', 2);
    });
  });
}
