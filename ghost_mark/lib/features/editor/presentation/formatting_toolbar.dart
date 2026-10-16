import 'package:flutter/material.dart';
import 'package:ghost_mark/features/editor/data/markdown_formatting.dart';

typedef Formatter = TextEditingValue Function(TextEditingValue value);

/// One-tap Markdown syntax for the editor. Sits under the text field so it
/// rides directly above the keyboard while typing.
class FormattingToolbar extends StatelessWidget {
  final ValueChanged<Formatter> onFormat;

  const FormattingToolbar({super.key, required this.onFormat});

  static final _actions = <(IconData, String, Formatter)>[
    (Icons.title, 'Heading', (v) => toggleLinePrefix(v, headingPrefix)),
    (Icons.format_bold, 'Bold', (v) => toggleWrap(v, '**')),
    (Icons.format_italic, 'Italic', (v) => toggleWrap(v, '*')),
    (Icons.format_list_bulleted, 'Bulleted list',
        (v) => toggleLinePrefix(v, bulletPrefix)),
    (Icons.checklist, 'Checklist',
        (v) => toggleLinePrefix(v, checklistPrefix)),
    (Icons.link, 'Link', insertLink),
    (Icons.code, 'Code', (v) => toggleWrap(v, '`')),
  ];

  @override
  Widget build(BuildContext context) {
    // Taps here count as part of the text field, so it keeps focus and the
    // keyboard stays open.
    return TextFieldTapRegion(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (icon, label, formatter) in _actions)
              IconButton(
                icon: Icon(icon),
                tooltip: label,
                onPressed: () => onFormat(formatter),
              ),
          ],
        ),
      ),
    );
  }
}
