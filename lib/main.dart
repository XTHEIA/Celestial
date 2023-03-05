import 'package:celestial/game_cellophane.dart';
import 'package:celestial/game_color1.dart';
import 'package:celestial/game_hidden.dart';
import 'package:celestial/game_presskey.dart';
import 'package:celestial/game_rgbfind.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  _routes.clear();
  _routes.addAll({
    "/": (ctx) => const MainPage(),
    "/games": (ctx) => const Games(),
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
  _Game("color1", "Color 1", "test game", (ctx) => const ColorGame())
];
final _gamesCount = _games.length;
final Map<String, Widget Function(BuildContext context)> _routes = {};

class CelestialApp extends StatelessWidget {
  const CelestialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Celestial",
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      initialRoute: "/",
      routes: _routes,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('main page'),
            MaterialButton(child: Text('games'), onPressed: () => Navigator.pushNamed(context, "/games"))
          ],
        ),
      ),
    );
  }
}

class Games extends StatefulWidget {
  const Games({Key? key}) : super(key: key);

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text("Celestial MiniGames"),
      //       Switch(
      //         value: cheat,
      //         onChanged: (v) => setState(() => cheat = v),
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          Text('${_gamesCount}개의 게임이 있습니다.'),
          Expanded(
            child: ListView.builder(
              itemCount: _gamesCount + 500,
              itemBuilder: (ctx, idx) {
                if (idx >= _gamesCount) {
                  final hidden = idx == 150;
                  return ListTile(
                    leading: const FlutterLogo(),
                    title: Text('empty game $idx'),
                    subtitle: Text('subtitle'),
                    onTap: hidden
                        ? () => Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => GameHidden()))
                        : () => ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,
                                content: Text('no game!'),
                                duration: Duration(milliseconds: 650),
                              ),
                            ),
                  );
                }
                final game = _games[idx];
                return ListTile(
                  leading: const FlutterLogo(),
                  title: Text("$idx : ${game.name}"),
                  subtitle: Text(game.description),
                  onTap: () => Navigator.pushNamed(ctx, "/game/${game.id}"),
                );
              },
            ),
          ),
        ],
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
