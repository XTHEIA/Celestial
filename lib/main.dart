import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:celestial/game/game.dart';
import 'dart:html';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(CelestialApp());
}

bool isMobile =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
bool darkMode = false;

class CelestialApp extends StatelessWidget {
  CelestialApp({Key? key}) : super(key: key);

  final Map<String, Function(BuildContext)> routes = {};

  void _registerSlideRoute(String name, Widget Function(BuildContext) builder, Offset beginOffset, Curve curve) {
    routes[name] = (ctx) => createSlideRouteName(name, builder, beginOffset, curve);
  }

  static Route router(Map<String, String> query) {
    builder(ctx) => CelestialHome(
          query: query,
        );
    final RouteSettings settings = RouteSettings();

    return MaterialPageRoute(builder: builder, settings: settings);
  }

  @override
  Widget build(BuildContext context) {
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

        final queryParameters = Uri.base.queryParameters;

        log("name : " + name.toString());
        log("args : " + args.toString());
        log("query : " + queryParameters.toString());

        return router(Map.of(queryParameters));
      },
    );
  }
}

class CelestialHome extends StatefulWidget {
  const CelestialHome({Key? key, required this.query}) : super(key: key);
  final Map<String, String> query;

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

  final List<_Tab> _tabs = [];
  String _currentTabID = "";

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _tabs.addAll([
      _Tab(
          "games",
          "게임",
          Icons.videogame_asset,
          (c, q) => GamesPage(
                queries: q,
              )),
      _Tab("cover", "커버", Icons.book, (context, query) {
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
      _Tab("info", "정보", Icons.info, (ctx, query) => Text('정보')),
    ]);

    _currentTabID = _tabs[0].id;
  }

  @override
  Widget build(BuildContext context) {
    // final queryTab = query["tab"];
    // if (queryTab != null) {
    //   log("Tab Query : " + queryTab);
    //   for (var tab in _tabs) {
    //     if (tab.id == queryTab) {
    //       _currentTabID = tab.id;
    //     }
    //   }
    // }

    late _Tab currentTab;
    for (var tab in _tabs) {
      if (tab.id == _currentTabID) {
        currentTab = tab;
      }
    }

    pushURL(currentTab.id);
    final Map<String, String> _passQueries = Map.unmodifiable(widget.query);
    widget.query.clear();

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: ListView.builder(
              itemCount: _tabs.length,
              itemBuilder: (ctx, idx) {
                final tab = _tabs[idx];
                return InkWell(
                  onTap: () => setState(() => _currentTabID = tab.id),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(tab.iconData),
                        Text(tab.name),
                      ],
                    ),
                    // title: Text(page.name),
                  ),
                );
              },
            ),
          ),
          Container(
            child: currentTab.builder.call(context, _passQueries),
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

PageRouteBuilder createSlideRouteName(
    String name, Widget Function(BuildContext) builder, Offset beginOffset, Curve curve) {
  return createSlideRouteSettings(RouteSettings(name: name), builder, beginOffset, curve);
}

PageRouteBuilder createSlideRouteSettings(
    RouteSettings settings, Widget Function(BuildContext) builder, Offset beginOffset, Curve curve) {
  return PageRouteBuilder(
    fullscreenDialog: false,
    settings: settings,
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

void pushURL(String url) {
  window.history.pushState(null, 'home', url);
}

class _Tab {
  String id;
  String name;
  IconData iconData;
  Widget Function(BuildContext, Map<String, String>) builder;

  _Tab(this.id, this.name, this.iconData, this.builder);
}
