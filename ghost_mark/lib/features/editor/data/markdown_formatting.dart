import 'package:flutter/services.dart';

/// A line-start marker, such as a heading or list item.
///
/// [family] lists the markers that occupy the same slot, longest first, so
/// applying one replaces another instead of stacking (`- ` → `- [ ] `).
class LinePrefix {
  final String text;
  final List<String> family;

  const LinePrefix(this.text, this.family);
}

const _headings = ['###### ', '##### ', '#### ', '### ', '## ', '# '];
const _listItems = ['- [ ] ', '- [x] ', '- [X] ', '- '];

const headingPrefix = LinePrefix('# ', _headings);
const bulletPrefix = LinePrefix('- ', _listItems);
const checklistPrefix = LinePrefix('- [ ] ', _listItems);

TextSelection _selectionOf(TextEditingValue value) => value.selection.isValid
    ? value.selection
    : TextSelection.collapsed(offset: value.text.length);

/// Surrounds the selection with [marker], or removes [marker] if it already
/// surrounds the selection. With nothing selected, inserts a pair and leaves
/// the cursor between them.
TextEditingValue toggleWrap(TextEditingValue value, String marker) {
  final text = value.text;
  final sel = _selectionOf(value);
  final start = sel.start;
  final end = sel.end;
  final n = marker.length;

  final isWrapped = start >= n &&
      end + n <= text.length &&
      text.substring(start - n, start) == marker &&
      text.substring(end, end + n) == marker;

  if (isWrapped) {
    return TextEditingValue(
      text: text.replaceRange(end, end + n, '').replaceRange(start - n, start, ''),
      selection: TextSelection(baseOffset: start - n, extentOffset: end - n),
    );
  }

  return TextEditingValue(
    text: text.replaceRange(
        start, end, '$marker${text.substring(start, end)}$marker'),
    selection: TextSelection(baseOffset: start + n, extentOffset: end + n),
  );
}

/// Turns the selection into `[selection](url)` and selects `url` so it can be
/// typed over. With nothing selected, leaves the cursor inside the brackets.
TextEditingValue insertLink(TextEditingValue value) {
  final text = value.text;
  final sel = _selectionOf(value);
  final label = text.substring(sel.start, sel.end);
  final link = '[$label](url)';
  final newText = text.replaceRange(sel.start, sel.end, link);

  if (label.isEmpty) {
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: sel.start + 1),
    );
  }
  final urlStart = sel.start + label.length + 3;
  return TextEditingValue(
    text: newText,
    selection: TextSelection(baseOffset: urlStart, extentOffset: urlStart + 3),
  );
}

/// Toggles [prefix] at the start of every line touched by the selection.
///
/// If every line already starts with it, it is removed. Otherwise each line
/// gets it, replacing any other marker from the same family.
TextEditingValue toggleLinePrefix(TextEditingValue value, LinePrefix prefix) {
  final text = value.text;
  final sel = _selectionOf(value);
  final lines = text.split('\n');

  // Start offset of each line, and the range of lines the selection touches.
  final lineStarts = <int>[];
  var offset = 0;
  for (final line in lines) {
    lineStarts.add(offset);
    offset += line.length + 1;
  }
  int lineAt(int offset) =>
      lineStarts.lastIndexWhere((lineStart) => lineStart <= offset);
  final first = lineAt(sel.start);
  final last = lineAt(sel.end);

  String existing(String line) =>
      prefix.family.firstWhere(line.startsWith, orElse: () => '');

  final remove = [
    for (var i = first; i <= last; i++) existing(lines[i]) == prefix.text
  ].every((has) => has);

  final oldLengths = <int>[];
  final newLengths = <int>[];
  for (var i = first; i <= last; i++) {
    final old = existing(lines[i]);
    final replacement = remove ? '' : prefix.text;
    oldLengths.add(old.length);
    newLengths.add(replacement.length);
    lines[i] = replacement + lines[i].substring(old.length);
  }

  // Maps an offset in the old text to the new text. An offset inside a
  // replaced marker is clamped to the end of the new marker.
  int map(int offset) {
    final line = lineAt(offset);
    var shift = 0;
    for (var i = first; i < line && i <= last; i++) {
      shift += newLengths[i - first] - oldLengths[i - first];
    }
    if (line < first || line > last) return offset + shift;

    final inLine = offset - lineStarts[line];
    final oldLength = oldLengths[line - first];
    final newLength = newLengths[line - first];
    final newInLine = inLine >= oldLength
        ? newLength + inLine - oldLength
        : (inLine < newLength ? inLine : newLength);
    return lineStarts[line] + shift + newInLine;
  }

  return TextEditingValue(
    text: lines.join('\n'),
    selection: TextSelection(
      baseOffset: map(sel.start),
      extentOffset: map(sel.end),
    ),
  );
}
