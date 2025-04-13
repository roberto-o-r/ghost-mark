import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ghost_mark/features/editor/presentation/editor_screen.dart';
import 'package:ghost_mark/features/preview/presentation/preview_screen.dart';
import 'package:ghost_mark/shared/custom_app_bar.dart';

class MainScreen extends HookWidget {
  const MainScreen({super.key});

  static const List<Widget> screens = [
    EditorScreen(),
    PreviewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    void onIndexChanged(int index) {
      currentIndex.value = index;
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: screens[currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: onIndexChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wysiwyg),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.preview),
            label: 'View',
          ),
        ],
      ),
    );
  }
}
