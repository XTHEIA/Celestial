import 'package:celestial/game_cellophane.dart';
import 'package:celestial/game_presskey.dart';
import 'package:celestial/game_rgbfind.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CelestialApp());
}

bool cheat = false;

final List<_Game> _games = [
  _Game("brighter", "Cellophane", "더 밝게 보이는 색 찾기", (ctx) => const GameCellophane()),
  _Game("rgb_element", "RGB Find", "특정 RGB 요소의 비율 찾아내기", (ctx) => const GameFindRGB()),
  _Game("key_press", "Key Press", "key input", (ctx) => const GameKeyPress()),
];

class CelestialApp extends StatelessWidget {
  const CelestialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Celestial",
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      color: Colors.blue,
      home: const CelestialHome(),
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
            onTap: () => Navigator.push(
                ctx,
                CupertinoPageRoute(
                    builder: (ctx) => Scaffold(
                        appBar: AppBar(
                          title: Text("${cheat ? "(Cheat Mode) " : ""}${game.name}"),
                        ),
                        body: Center(
                          child: game.scene(ctx),
                        )),
                    fullscreenDialog: false,
                    settings: RouteSettings(name: "/${game.name}"))),
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
