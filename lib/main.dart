import 'package:celestial/game_cellophane.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CelestialApp());
}

class CelestialApp extends StatelessWidget {
  const CelestialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
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
  static final List<_Game> games = [
    _Game("Cellophane", "더 밝게 보이는 색 찾기", (ctx) => const GameCellophane()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Celestial MiniGames"),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (ctx, idx) {
          final game = games[idx];
          return ListTile(
            leading: const FlutterLogo(),
            title: Text(game.name),
            subtitle: Text(game.description),
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                        appBar: AppBar(
                          title: Text(game.name),
                        ),
                        body: game.scene(ctx)),
                    fullscreenDialog: false,
                    settings: RouteSettings(name: "/${game.name}"))),
          );
        },
      ),
    );
  }
}

class _Game {
  String name;
  String description;
  Func<BuildContext, Widget> scene;

  _Game(this.name, this.description, this.scene);
}

typedef Supplier<T> = T Function();
typedef Func<P, R> = R Function(P param);
