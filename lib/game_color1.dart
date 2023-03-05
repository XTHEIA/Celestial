import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(ColorGame());

class ColorGame extends StatelessWidget {
  const ColorGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Game',
      home: ColorGamePage(),
    );
  }
}

class ColorGamePage extends StatefulWidget {
  @override
  _ColorGamePageState createState() => _ColorGamePageState();
}

class _ColorGamePageState extends State<ColorGamePage> {
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  Random _random = Random();
  late Color _targetColor;
  int _score = 0;

  void _generateTargetColor() {
    setState(() {
      _targetColor = _colors[_random.nextInt(_colors.length)];
    });
  }

  void _onColorButtonPressed(Color color) {
    if (color == _targetColor) {
      setState(() {
        _score++;
      });
      _generateTargetColor();
    } else {
      setState(() {
        _score = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _generateTargetColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tap the color that matches the background',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              color: _targetColor,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorButton(color: Colors.red, onPressed: () => _onColorButtonPressed(Colors.red)),
                ColorButton(color: Colors.blue, onPressed: () => _onColorButtonPressed(Colors.blue)),
                ColorButton(color: Colors.green, onPressed: () => _onColorButtonPressed(Colors.green)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorButton(color: Colors.yellow, onPressed: () => _onColorButtonPressed(Colors.yellow)),
                ColorButton(color: Colors.purple, onPressed: () => _onColorButtonPressed(Colors.purple)),
                ColorButton(color: Colors.orange, onPressed: () => _onColorButtonPressed(Colors.orange)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const ColorButton({required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: Size(80, 80),
        shape: CircleBorder(),
      ),
      child: SizedBox(),
    );
  }
}
