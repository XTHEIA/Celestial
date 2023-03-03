// 다음 중 어떤 색에 파란색이 더 많이 포함되어 있나요?

import 'dart:math' as math;
import 'package:calc/calc.dart';

import 'package:flutter/material.dart';

class GameFindRGB extends StatefulWidget {
  const GameFindRGB({Key? key}) : super(key: key);

  @override
  State<GameFindRGB> createState() => _GameFindRGBState();
}

class _GameFindRGBState extends State<GameFindRGB> {
  int score = 0;
  _State gameState = _State.READY;

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (gameState) {
      case _State.READY:
        body = MaterialButton(
          color: Colors.blue,
          onPressed: () => setState(() => gameState = _State.GAME),
        );
        break;
      case _State.GAME:
        final newQuestion = _Question.random(2);
        final colors = newQuestion.colors;
        final count = colors.length;
        final List<Widget> tiles = List.filled(count, Placeholder());
        for (int i = 0; i < count; i += 1) {
          final isAnswer = newQuestion.answerIdx == i;
          final color = colors[i];
          tiles[i] = MaterialButton(
            color: color,
            onPressed: () {
              if (isAnswer) {
                setState(() => this.score += newQuestion.difficulty);
              } else {
                setState(() => gameState = _State.OVER);
              }
            },
          );
        }
        body = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("pick " + newQuestion.find.toString()),
            Row(
              children: tiles,
            )
          ],
        );
        break;
      case _State.OVER:
        body = Text("score is " + score.toString());
        break;
    }

    return Center(
      child: body,
    );
  }
}

enum _State {
  READY,
  GAME,
  OVER,
}

class _Question {
  List<Color> colors;
  _RGB find;
  int difficulty;
  int answerIdx;

  _Question(this.colors, this.find, this.difficulty, this.answerIdx);

  static _Question random(int count) {
    assert(count >= 2);
    final List<int> elementValues = List.filled(count, 0);
    int biggestValue = 0, answerIdx = 0;
    for (int i = 0; i < count; i++) {
      int val = math.Random().nextInt(256);
      if (val > biggestValue) {
        biggestValue = val;
        answerIdx = i;
      } else if (val == biggestValue) {
        val += 1;
        biggestValue = val;
        answerIdx = i;
      }
      elementValues[i] = val;
    }
    final difficulty = elementValues.standardDeviation() ~/ 0.01;
    final findE = _RGB.values[math.Random().nextInt(3)];
    final colors = elementValues.map((e) {
      switch (findE) {
        case _RGB.R:
          return Color.fromARGB(255, e, math.Random().nextInt(256), math.Random().nextInt(256));
        case _RGB.G:
          return Color.fromARGB(255, math.Random().nextInt(256), e, math.Random().nextInt(256));
        case _RGB.B:
          return Color.fromARGB(255, math.Random().nextInt(256), math.Random().nextInt(256), e);
      }
    }).toList(growable: false);

    return _Question(colors, findE, difficulty, answerIdx);
  }
}

enum _RGB {
  R,
  G,
  B,
}
