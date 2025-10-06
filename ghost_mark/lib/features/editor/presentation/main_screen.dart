import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ghost_mark/features/editor/presentation/editor_screen.dart';
import 'package:ghost_mark/features/preview/presentation/preview_screen.dart';
import 'package:ghost_mark/shared/custom_app_bar.dart';

class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    void onIndexChanged(int index) {
      currentIndex.value = index;
    }

  void openFile() => EditorScreen.openFileAction?.call(context);
  void saveFile() => EditorScreen.saveFileAction?.call(context);
  void clearFile() => EditorScreen.clearFileAction?.call(context);

    return Scaffold(
      appBar: currentIndex.value == 0
          ? CustomAppBar(
              onOpen: openFile,
              onSave: saveFile,
              onClear: clearFile,
            )
          : const CustomAppBar(),
      body: currentIndex.value == 0
          ? EditorScreen(
              provideOpen: (fn) => EditorScreen.openFileAction = fn,
              provideSave: (fn) => EditorScreen.saveFileAction = fn,
              provideClear: (fn) => EditorScreen.clearFileAction = fn,
            )
          : const PreviewScreen(),
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
