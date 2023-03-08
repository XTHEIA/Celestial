import 'package:flutter/material.dart';

import 'package:celestial/game/game.dart';

void main() {
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
    _registerSlideRoute("/", (p0) => const HomePage(), const Offset(-1.0, 0.0), Curves.ease);
    _registerSlideRoute("/games", (ctx) => const GamesPage(), const Offset(0.0, 1.0), Curves.ease);
    for (var game in games) {
      _registerSlideRoute("/games/${game.id}", game.route, const Offset(1.0, 0.0), Curves.ease);
    }

    final lightTheme = ThemeData.light();
    final darkTheme = ThemeData.dark();

    return MaterialApp(
      title: "Celestial",
      theme: darkMode ? darkTheme : lightTheme,
      initialRoute: "/",
      onGenerateRoute: (routeSettings) {
        final name = routeSettings.name;
        final args = routeSettings.arguments;
        final routeFunc = routes[name];
        if (routeFunc == null) {
          return MaterialPageRoute(builder: (ctx) => const Text('empty page'), fullscreenDialog: true);
        }
        return routeFunc.call(context);
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Widget _createNavigatorButton(String name, String nav) {
  //   return MaterialButton(
  //       child: Text(name, style: const TextStyle(fontSize: 30)),
  //       height: 40,
  //       minWidth: double.infinity,
  //       onPressed: () => Navigator.pushn Navigator.pushNamed(context, nav),);
  // }

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
                            duration: Duration(milliseconds: 350),
                            curve: Curves.easeInOutBack,
                            size: double.infinity,
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
                Text('Average Score : 55',style: Theme.of(context).textTheme.titleLarge,),
              ],
            ),
            /* BUTTONS */
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    height: 45,
                    minWidth: double.infinity,
                    child: const Text('GAMES', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/games");
                    }),
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

PageRouteBuilder createSlideRoute(String name, Widget Function(BuildContext) builder, Offset beginOffset, Curve curve) {
  return PageRouteBuilder(
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
