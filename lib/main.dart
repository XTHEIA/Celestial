import 'package:celestial/game_cellophane.dart';
import 'package:celestial/game_color1.dart';
import 'package:celestial/game_presskey.dart';
import 'package:celestial/game_rgbfind.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  _routes.clear();
  _routes.addAll({
    "/": (ctx) => const CelestialHome(),
  });

  for (var game in _games) {
    _routes.addAll({
      "/game/${game.id}": game.route,
    });
  }
  runApp(const CelestialApp());
}

bool cheat = false;

final List<_Game> _games = [
  _Game("brighter", "Cellophane", "더 밝게 보이는 색 찾기", (ctx) => const GameCellophane()),
  _Game("rgb_element", "RGB Find (매우 어려움)", "특정 RGB 요소의 비율 찾아내기", (ctx) => const GameFindRGB()),
  _Game("key_press", "Key Press", "key input", (ctx) => const GameKeyPress()),
  _Game("color1","Color 1","test game", (ctx) => const ColorGame())
];
final Map<String, Widget Function(BuildContext context)> _routes = {};

class CelestialApp extends StatelessWidget {
  const CelestialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Celestial",
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      color: Colors.blue,
      initialRoute: "/",
      routes: _routes,
    );
  }
}

class CelestialHome extends StatefulWidget {
  const CelestialHome({Key? key}) : super(key: key);

  @override
  State<CelestialHome> createState() => _CelestialHomeState();
}

class _CelestialHomeState extends State<CelestialHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Celestial MiniGames"),
            Switch(
              value: cheat,
              onChanged: (v) => setState(() => cheat = v),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (ctx, idx) {
          final game = _games[idx];
          return ListTile(
            leading: const FlutterLogo(),
            title: Text(game.name),
            subtitle: Text(game.description),
            onTap: () => Navigator.pushNamed(ctx, "/game/${game.id}"),
          );
        },
      ),
    );
  }
}

class _Game {
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

  _Game(this.id, this.name, this.description, this.scene);
}

// typedef Supplier<T> = T Function();
// typedef Func<P, R> = R Function(P param);

MaterialButton createGameStartButton({void Function()? onPressed}) {
  return MaterialButton(
    onPressed: onPressed,
    minWidth: 200,
    color: Colors.blue,
    child: const Text("START"),
  );
}

MaterialButton createCellophane(Color color, void Function() onPressed) {
  return MaterialButton(
    height: 100,
    minWidth: 100,
    color: color,
    onPressed: onPressed,
  );
}
