import 'package:flutter/material.dart';

class GameHidden extends StatefulWidget {
  const GameHidden({Key? key}) : super(key: key);

  @override
  State<GameHidden> createState() => _GameHiddenState();
}

class _GameHiddenState extends State<GameHidden> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('hidden game'),);
  }
}
