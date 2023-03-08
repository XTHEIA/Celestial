import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:celestial/game/game.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  // setPathUrlStrategy();
  runApp(CelestialApp());
}

bool darkMode = false;

class CelestialApp extends StatelessWidget {
  CelestialApp({Key? key}) : super(key: key);

  final Map<String, Function(BuildContext)> routes = {};

  void _registerSlideRoute(String name, Widget Function(BuildContext) builder, Offset beginOffset, Curve curve) {
    routes[name] = (ctx) => createSlideRoute(name, builder, beginOffset, curve);
  }

  @override
  Widget build(BuildContext context) {
    _registerSlideRoute("/", (p0) => const CelestialHome(), const Offset(-1.0, 0.0), Curves.ease);
    _registerSlideRoute("/games", (ctx) => const GamesPage(), const Offset(0.0, 1.0), Curves.ease);
    for (var game in games) {
      _registerSlideRoute("/games/${game.id}", game.route, const Offset(1.0, 0.0), Curves.ease);
    }

    final lightTheme = ThemeData.light().copyWith();
    final darkTheme = ThemeData.dark();
    return MaterialApp(
      title: "Celestial",
      initialRoute: "/",
      theme: darkMode ? darkTheme : lightTheme,
      // initialRoute: "/",
      onGenerateRoute: (routeSettings) {
        final name = routeSettings.name;
        final args = routeSettings.arguments;

        return routes[name]!.call(context);
      },
    );
  }
}

class CelestialHome extends StatefulWidget {
  const CelestialHome({Key? key}) : super(key: key);

  @override
  State<CelestialHome> createState() => _CelestialHomeState();
}

class _CelestialHomeState extends State<CelestialHome> {
  // Widget _createNavigatorButton(String name, String nav) {
  //   return MaterialButton(
  //       child: Text(name, style: const TextStyle(fontSize: 30)),
  //       height: 40,
  //       minWidth: double.infinity,
  //       onPressed: () => Navigator.pushn Navigator.pushNamed(context, nav),);
  // }

  final List<_Page> _pages = [];
  int _selectedPageIdx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages.addAll([
      _Page("게임", Icons.videogame_asset, (ctx) => GamesPage()),
      _Page("커버", Icons.book, (context) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('top bar'),
                    ],
                  ),
                  const SizedBox(height: 160),
                  /* TITLE */
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 100,
                          child: GestureDetector(
                            onDoubleTap: () => setState(() => cheat = !cheat),
                            child: FlutterLogo(
                              size: 400,
                              duration: Duration(milliseconds: 350),
                              curve: Curves.easeInOutBack,
                              textColor: cheat ? Colors.red : Colors.grey.shade700,
                              style: cheat ? FlutterLogoStyle.stacked : FlutterLogoStyle.horizontal,
                            ),
                          )),
                      Text('v1.0.0${cheat ? ' (cheat)' : ''}'),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Average Score : 55',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              /* BUTTONS */
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      height: 45,
                      child: const Text('GAMES', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/games");
                      }),
                  const SizedBox(height: 150),
                ],
              ),
            ],
          ),
        );
      }),
      _Page("정보", Icons.info, (ctx) => Text('정보')),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _pages.length,
              itemBuilder: (ctx, idx) {
                final page = _pages[idx];
                return ListTile(
                  onTap: () => setState(() => _selectedPageIdx = idx),
                  leading: Icon(page.iconData),
                  title: Text(page.name),
                );
              },
            ),
          ),
          Container(
            child: _pages[_selectedPageIdx].builder.call(context),
          ),
        ],
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

PageRouteBuilder createSlideRoute(String name, Widget Function(BuildContext) builder, Offset beginOffset, Curve curve) {
  return PageRouteBuilder(
    fullscreenDialog: false,
    settings: RouteSettings(name: name),
    pageBuilder: (ctx, a1, a2) => builder.call(ctx),
    transitionsBuilder: (ctx, a1, a2, child) {
      const end = Offset.zero;
      final tween = Tween(begin: beginOffset, end: end);
      final curvedAnimation = CurvedAnimation(parent: a1, curve: curve);
      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

class _Page {
  String name;
  IconData iconData;
  Widget Function(BuildContext) builder;

  _Page(this.name, this.iconData, this.builder);
}
