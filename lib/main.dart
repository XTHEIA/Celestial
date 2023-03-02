import 'package:celestial/game_cellophane.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CelestialApp());
}

class CelestialApp extends StatelessWidget {
  const CelestialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GameCellophane(),
    );
  }
}
