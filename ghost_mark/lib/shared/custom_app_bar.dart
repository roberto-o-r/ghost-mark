import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final VoidCallback? onOpen;
  final VoidCallback? onSave;
  final VoidCallback? onClear;

  const CustomAppBar({super.key, this.onOpen, this.onSave, this.onClear})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          Image.asset(
            'assets/images/text-logo.png',
            height: 50,
          ),
        ],
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
      ],
    );
  }
}
