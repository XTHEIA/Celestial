// 다음 중 어떤 색에 파란색이 더 많이 포함되어 있나요?

import 'dart:math' as math;
import 'package:calc/calc.dart';
import 'package:celestial/Cellophane.dart';
import 'package:celestial/main.dart';

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
        body = createGameStartButton(
          onPressed: () => setState(() => gameState = _State.GAME),
        );
        break;
      case _State.GAME:
        final newQuestion = _Question.random(math.Random().nextInt(4) + 2);
        final colors = newQuestion.colors;
        final count = colors.length;
        final find = newQuestion.find;
        final List<Widget> tiles = List.empty(growable: true);
        for (int i = 0; i < count; i += 1) {
          final isAnswer = newQuestion.answerIdx == i;
          final color = colors[i];
          tiles.add(Cellophane(
            color: color,
            onPressed: () {
              if (isAnswer) {
                setState(() => this.score += newQuestion.difficulty);
              } else {
                setState(() => gameState = _State.OVER);
              }
            },
            child: (cheat)
                ? Column(
                    children: [
                      Text(isAnswer ? "ANSWER" : ""),
                      Text("${color.red},${color.green},${color.blue}"),
                    ],
                  )
                : null,
          ));
          if (i != count - 1) {
            tiles.add(const SizedBox(width: 20));
          }
        }
        body = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('다음 색들 중 '),
                Text(
                  find.name,
                  style: TextStyle(color: find.color, fontSize: 25),
                ),
                Text('이 가장 많이 포함 된 색은 무엇인가요?'),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
    final difficulty = elementValues.standardDeviation() ~/ 1;
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
  R('빨강', Color.fromARGB(255, 255, 0, 0)),
  G('초록', Color.fromARGB(255, 0, 255, 0)),
  B('파랑', Color.fromARGB(255, 0, 0, 255)),
  ;

  final String name;
  final Color color;

  const _RGB(this.name, this.color);
}
