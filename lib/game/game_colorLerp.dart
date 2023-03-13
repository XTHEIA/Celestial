import 'dart:math';

import 'package:celestial/Cellophane.dart';
import 'package:celestial/game/game.dart';
import 'package:flutter/material.dart';

class GameColorLerp extends StatefulWidget {
  const GameColorLerp({Key? key}) : super(key: key);

  @override
  State<GameColorLerp> createState() => _GameColorLerpState();
}

class _GameColorLerpState extends State<GameColorLerp> {
  bool isFinished = false;

  _Question? currentQuestion = _Question.random(Random().nextInt(2) + 1);
  Color currentColor = Colors.transparent;
  final List<int> selectedAnswers = [];
  final List<Color> selectedColors = [];
  int score = 0;
  bool isCorrect = true;

  @override
  Widget build(BuildContext context) {
    // 랜덤 색 여러개 생성.
    // 그둘 중 일부만 섞어서 "문제 (목표 색) 으로 출제.
    // 여러 색 전부 보기로.

    final q = currentQuestion!;
    final answers = q.answers;
    final answersCount = answers.length;
    final targetColor = q.target;

    var dif = currentColor.value - targetColor.value;
    if (dif < 0) dif = -dif;

    var similarity = 1.0 - (dif as double) / (Color(0XFFFFFFFF).value as double);

    return Center(
      child: isFinished
          ? Text('점수 : $score')
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('현재 점수 : $score'),
                const SizedBox(height: 15),
                Text('재료 ${q.answersCount}개를 사용해 목표를 합성하세요.'),
                const SizedBox(height: 5),
                Text('남은 선택 수 : ${q.answersCount - selectedAnswers.length}회'),
                Text(cheat ? '정답 : ${answers.toString()}' : ''),
                const SizedBox(height: 15),
                Cellophane(
                  color: targetColor,
                  onPressed: () {},
                ),
                const SizedBox(height: 5),
                const Text('이 색은 "목표" 입니다.'),
                const SizedBox(height: 30),
                Cellophane(
                  color: currentColor,
                  onPressed: () {},
                ),
                const SizedBox(height: 5),
                Builder(
                  builder: (ctx) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: selectedColors.map((c) {
                        return Container(
                          width: 10,
                          height: 10,
                          color: c,
                        );
                      }).toList(growable: false),
                    );
                  },
                ),
                const Text('이 색은 "현재" 입니다.'),
                const SizedBox(height: 35),
                Builder(
                  builder: (ctx) {
                    final options = q.options;
                    final optionsCount = options.length;
                    final List<Widget> tiles = List.empty(growable: true);
                    for (int i = 0; i < optionsCount; i++) {
                      final color = options[i];
                      final isAnswer = answers.contains(i);
                      final alreadySelected = selectedAnswers.contains(i);
                      if (alreadySelected) continue;
                      tiles.add(MaterialButton(
                        height: 50,
                        minWidth: 50,
                        color: color,
                        onPressed: alreadySelected
                            ? null
                            : () {
                                setState(() {
                                  if (!isAnswer) {
                                    isCorrect = false;
                                  }
                                  final curAnswersSize = selectedAnswers.length;
                                  selectedAnswers.add(i);
                                  selectedColors.add(color);
                                  currentColor = curAnswersSize == 0 ? color : Color.lerp(currentColor, color, 0.5)!;
                                  if (curAnswersSize + 1 == answersCount) {
                                    if (isCorrect) {
                                      score += q.difficulty * 15;
                                      isCorrect = true;
                                      currentQuestion = _Question.random(Random().nextInt(6) + 1);
                                      currentColor = Colors.transparent;
                                      selectedAnswers.clear();
                                      selectedColors.clear();
                                    } else {
                                      isFinished = true;
                                    }
                                  }
                                });
                              },
                        child: cheat && isAnswer ? Text('ANSWER') : null,
                      ));
                      // if (i != optionsCount - 1) {
                      //   tiles.add(const SizedBox(width: 10));
                      // }
                    }
                    return Row(
                      children: [
                        const Spacer(flex: 1),
                        Flexible(
                          flex: 4,
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            children: tiles,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 5),
                Text('이 색들은 "재료" 입니다.'),
              ],
            ),
    );
  }
}

class _Question {
  final int difficulty;
  final List<Color> options;
  final List<int> answers;
  final Color target;
  late final int answersCount = answers.length;

  _Question(this.options, this.answers, this.target, this.difficulty);

  static _Question random(int difficulty) {
    assert(difficulty >= 1);
    final optionsCount = difficulty + 3;
    // 보기가 5개면 : 섞는 수 2~4 -> (0~2) + 2
    // 보기가 6개면 : 섞는 수 2~5 -> (0~3) + 2
    final lerpCount = Random().nextInt(optionsCount - 2) + 2;

    final List<Color> options = List.filled(optionsCount, Color.fromARGB(0, 0, 0, 0));
    final List<int> lerpIdx = List.empty(growable: true);
    int lerpedCounter = 0;
    for (int i = 1; i <= optionsCount; i++) {
      options[i - 1] = Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
      final need = lerpCount - lerpedCounter;
      assert(need >= 0);
      if (need == 0) continue;
      final leftDraw = optionsCount - i + 1;
      assert(need <= leftDraw);
      final noChance = leftDraw == need;
      if (noChance || Random().nextInt(lerpCount) == 0) {
        lerpedCounter += 1;
        lerpIdx.add(i - 1);
      }
    }

    assert(lerpCount == lerpedCounter);
    assert(lerpCount == lerpIdx.length);

    late Color target;
    for (int i = 0; i < lerpCount; i++) {
      final color = options[lerpIdx[i]];
      if (i == 0) {
        target = color;
      } else {
        target = Color.lerp(target, color, 0.5)!;
      }
    }

    return _Question(options, lerpIdx, target, difficulty);
  }
}
