import 'dart:math';

import 'package:celestial/main.dart';
import 'package:flutter/material.dart';

class GameCellophane extends StatefulWidget {
  const GameCellophane({Key? key}) : super(key: key);

  @override
  State<GameCellophane> createState() => _GameCellophaneState();
}

class _GameCellophaneState extends State<GameCellophane> {
  _State state = _State.READY;
  int score = 0;

  void addScore(int score) {
    this.score += score;
  }

  Widget createChoice(Color color, bool isAnswer, int score) {
    return MaterialButton(
      color: color,
      highlightColor: color,
      height: 100,
      minWidth: 100,
      child: cheat ? Text(color.computeLuminance().toStringAsFixed(2)) : null,
      onPressed: () {
        setState(() {
          if (isAnswer) {
            this.score += score;
          } else {
            state = _State.END;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWidget;

    switch (state) {
      case _State.READY:
        mainWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("더 밝은 색을 찾으세요."),
            const SizedBox(height: 20),
            MaterialButton(
              minWidth: 200,
              color: Colors.blue,
              child: const Text("START"),
              onPressed: () => setState(() => state = _State.GAMING),
            ),
          ],
        );
        break;
      case _State.END:
        mainWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("점수 : $score"),
            const SizedBox(height: 50),
            MaterialButton(
              minWidth: 200,
              color: Colors.blue,
              onPressed: () => setState(() {
                score = 0;
                state = _State.READY;
              }),
              child: const Text("첫 화면으로"),
            ),
            const SizedBox(height: 40),
            const Text("밝기는 아래와 같은 공식에 따라 산출됩니다."),
            const SizedBox(height: 20),
            const Text("https://www.w3.org/TR/WCAG20/#relativeluminancedef"),
            const Text("https://en.wikipedia.org/wiki/Relative_luminance")
          ],
        );
        break;
      case _State.GAMING:
        final q = _Question.random();
        mainWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("현재 점수 : $score"),
            const SizedBox(height: 30),
            const Text("어떤 색이 더 밝은가요?"),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createChoice(q.color1, q.isColor1Brighter, q.difficulty),
                const SizedBox(width: 50),
                createChoice(q.color2, !q.isColor1Brighter, q.difficulty),
              ],
            ),
            const SizedBox(height: 20),
            Text("난이도 : ${q.difficulty}"),
          ],
        );
        break;
    }
    ;

    return Center(
      child: mainWidget,
    );
  }
}

class _Question {
  final Color color1;
  final double c1lux;
  final Color color2;
  final double c2lux;
  final int difficulty;
  final bool isColor1Brighter;

  _Question(this.color1, this.c1lux, this.color2, this.c2lux, this.difficulty, this.isColor1Brighter);

  static _Question random() {
    final c1 = Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));
    var c2 = Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));

    final l1 = c1.computeLuminance();
    var l2 = c2.computeLuminance();

    while (l1 == l2) {
      c2 = Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));
      l2 = c2.computeLuminance();
    }

    final difficulty = (1.0 - (l1 - l2).abs()) ~/ 0.1;

    return _Question(c1, l1, c2, l2, difficulty, l1 >= l2);
  }
}

enum _State {
  READY,
  GAMING,
  END,
}
