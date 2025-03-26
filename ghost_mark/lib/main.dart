import 'package:flutter/material.dart';
import 'package:ghost_mark/features/editor/presentation/editor_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const EditorScreen(),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
    );
  }
}
