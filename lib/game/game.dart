library game;

import 'package:celestial/game/game_cellophane.dart';
import 'package:celestial/game/game_color1.dart';
import 'package:celestial/game/game_colorLerp.dart';
import 'package:celestial/game/game_presskey.dart';
import 'package:celestial/game/game_rgbfind.dart';
import 'package:flutter/material.dart';

export 'package:celestial/game/page_games.dart';

bool cheat = false;
final List<Game> games = [
  Game("color_brighter", "컬러", "휘도 분별", Icons.brightness_medium_rounded, "쉬움", "더 밝게 보이는 색 찾기",
      (ctx) => const GameCellophane()),
  Game("rgb_dissolve", "컬러", "삼원색 분해", Icons.remove_red_eye, "매우 어려움", "특정 RGB 요소의 비율 찾아내기",
      (ctx) => const GameFindRGB()),
  Game('color_lerp', "컬러", "색 합성", Icons.width_normal_outlined, "어려움", "주어지는 색들을 사용해 목표 색을 합성해내세요.",
      (ctx) => const GameColorLerp()),
  Game("key_press", "키보드", "Key Press", Icons.keyboard, "쉬움", "key input", (ctx) => const GameKeyPress()),
  Game("color1", "컬러", "테스트", Icons.travel_explore_sharp, "테스트 게임", "test game", (ctx) => const ColorGame())
];
final gamesCount = games.length;

class Game {
  IconData iconData;
  String id;
  String category;
  String name;
  String description;
  String difficulty;
  Widget Function(BuildContext context) scene;
  late Widget Function(BuildContext context) route = (ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${cheat ? "(Cheat Mode) " : ""}$name"),
      ),
      body: Center(
        child: scene(ctx),
      ),
    );
  };

  Game(this.id, this.category, this.name, this.iconData, this.difficulty, this.description, this.scene);
}
