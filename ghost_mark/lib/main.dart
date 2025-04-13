import 'package:flutter/material.dart';
import 'package:ghost_mark/features/editor/presentation/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: Colors.black, secondary: Colors.black)),
    );
  }
}
