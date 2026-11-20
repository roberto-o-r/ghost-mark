import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final VoidCallback? onOpen;
  final VoidCallback? onSave;
  final VoidCallback? onClear;
  final VoidCallback? onFeedback;
  final VoidCallback? onRate;
  final VoidCallback? onPrivacy;

  const CustomAppBar(
      {super.key,
      this.onOpen,
      this.onSave,
      this.onClear,
      this.onFeedback,
      this.onRate,
      this.onPrivacy})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: SizedBox(
        height: 50,
        child: Image.asset(
          'assets/images/text-logo.png',
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
        ),
      ),
      forceMaterialTransparency: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.folder_open),
          tooltip: 'Open',
          onPressed: onOpen,
        ),
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Save',
          onPressed: onSave,
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Clear',
          onPressed: onClear,
        ),
        PopupMenuButton<String>(
          tooltip: 'More options',
          onSelected: (action) {
            switch (action) {
              case 'feedback':
                onFeedback?.call();
              case 'rate':
                onRate?.call();
              case 'privacy':
                onPrivacy?.call();
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
                value: 'feedback', child: Text('Share feedback')),
            if (onRate != null)
              const PopupMenuItem(value: 'rate', child: Text('Rate GhostMark')),
            const PopupMenuItem(
                value: 'privacy', child: Text('Privacy policy')),
          ],
        ),
      ],
    );
  }
}
