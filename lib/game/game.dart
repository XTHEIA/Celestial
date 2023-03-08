library game;

import 'package:celestial/game/game_cellophane.dart';
import 'package:celestial/game/game_color1.dart';
import 'package:celestial/game/game_presskey.dart';
import 'package:celestial/game/game_rgbfind.dart';
import 'package:flutter/material.dart';

export 'package:celestial/game/page_games.dart';

bool cheat = false;
final List<Game> games = [
  Game("brighter", "Cellophane", "더 밝게 보이는 색 찾기", (ctx) => const GameCellophane()),
  Game("rgb_element", "RGB Find (매우 어려움)", "특정 RGB 요소의 비율 찾아내기", (ctx) => const GameFindRGB()),
  Game("key_press", "Key Press", "key input", (ctx) => const GameKeyPress()),
  Game("color1", "Color 1", "test game", (ctx) => ColorGame())
];
final gamesCount = games.length;

class Game {
  String id;
  String name;
  String description;
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

  Game(this.id, this.name, this.description, this.scene);
}
