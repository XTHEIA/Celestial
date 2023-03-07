import 'dart:io';

import 'package:celestial/game/game.dart';
import 'package:celestial/game/game_hidden.dart';
import 'package:celestial/page_games.dart';
import 'package:flutter/material.dart';

void main() {
  _routes.clear();
  _routes.addAll({
    "/": (ctx) => const HomePage(),
    "/games": (ctx) => const GamesPage(),
  });

  for (var game in games) {
    _routes.addAll({
      "/game/${game.id}": game.route,
    });
  }
  runApp(const CelestialApp());
}

bool cheat = false;

final Map<String, Widget Function(BuildContext context)> _routes = {};

class CelestialApp extends StatelessWidget {
  const CelestialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Celestial",
      themeMode: ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: "/",
      routes: _routes,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _createNavigatorButton(String name, String nav) {
    return MaterialButton(
      child: Text(name, style: const TextStyle(fontSize: 30)),
      height: 55,
      minWidth: 500,
      onPressed: () => Navigator.pushNamed(context, nav),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                Text('top bar'),
                const SizedBox(height: 180),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                        height: 120,
                        child: FlutterLogo(
                          size: double.infinity,
                          duration: Duration(seconds: 2),
                          style: FlutterLogoStyle.horizontal,
                        )),
                    Text('v1.0.0'),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _createNavigatorButton("게임 목록", "/games"),
                _createNavigatorButton("버튼 2", "2"),
                _createNavigatorButton("버튼 2", "2"),
                _createNavigatorButton("버튼 2", "2"),
                const SizedBox(height: 150),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
