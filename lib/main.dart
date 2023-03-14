import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:celestial/game/game.dart';
import 'dart:math';
import 'dart:html';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(CelestialApp());
}

bool isMobile =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

class CelestialApp extends StatelessWidget {
  CelestialApp({Key? key}) : super(key: key);

  final Map<String, Function(BuildContext)> routes = {};

  void _registerSlideRoute(String name, Widget Function(BuildContext) builder, Offset beginOffset, Curve curve) {
    routes[name] = (ctx) => createSlideRouteName(name, builder, beginOffset, curve);
  }

  static Widget router(Map<String, String> query) {
    builder(ctx) => CelestialHome(
          query: query,
        );
    final RouteSettings settings = const RouteSettings();

    // return MaterialPageRoute(builder: builder, settings: settings);
    return CelestialHome(
      query: query,
    );
  }

  @override
  Widget build(BuildContext context) {
    final queryParameters = Uri.base.queryParameters;
    dev.log("query : " + queryParameters.toString());
    return router(Map.of(queryParameters));
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

  late final Map<String, String> initialQueries, queries;
  final List<_Tab> tabs = [];
  late _Tab currentTab;
  _Tab? hoveringTab = null;
  bool isDarkMode = true;
  late ThemeData themeData = (isDarkMode ? ThemeData.dark() : ThemeData.light()).copyWith(
    primaryColor: Colors.tealAccent,
  );

  void setTheme(bool isDarkMode, ThemeData data) {
    setState(() {
      this.isDarkMode = isDarkMode;
      this.themeData = data;
    });
  }

  @override
  void initState() {
    super.initState();

    initialQueries = Map.unmodifiable(widget.query);
    queries = Map.of(widget.query);

    tabs.addAll([
      _Tab(
          "profile",
          "프로필",
          Icons.person,
          (c, q) => const Center(
                child: Text('profile'),
              )),
      _Tab(
          "games",
          "게임",
          Icons.videogame_asset,
          (c, q) => GamesPage(
                queries: q,
              )),
      _Tab("cover", "커버", Icons.book, (context, query) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
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
                            duration: const Duration(milliseconds: 350),
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
        );
      }),
      _Tab("info", "정보", Icons.info, (ctx, query) => const Center(child: Text('정보'))),
      _Tab(
          'source',
          '소스',
          Icons.code,
          (ctx, query) => Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('https://github.com/XTHEIA/celestial'),
                  Text('https://xtheia.github.io/celestial/'),
                ],
              ))),
    ]);
    currentTab = tabs[0];

    final tabQuery = queries["tab"];
    if (tabQuery != null) {
      for (final tab in tabs) {
        if (tab.id == tabQuery) {
          currentTab = tab;
          queries.remove("tab");
        }
      }
    }
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

    pushURL("?tab=${currentTab.id}");
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 82,
                          width: 82,
                          padding: const EdgeInsets.all(17.0),
                          child: const FlutterLogo(),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: tabs.length,
                            itemBuilder: (ctx, idx) {
                              final tab = tabs[idx];
                              final isHovering = tab == hoveringTab;
                              final isSelected = tab == currentTab;
                              final color = themeData.primaryColor;
                              //(isDarkMode ? themeData.primaryColorLight : themeData.primaryColorDark);
                              // TODO 이것도 PageGames처럼 마우스 올리면 늘어나는 효과..?
                              return InkWell(
                                onHover: (b) => setState(() => hoveringTab = tab),
                                onTap: () => setState(() => currentTab = tab),
                                child: Container(
                                  height: 85,
                                  color: isSelected
                                      ? Color.lerp(themeData.scaffoldBackgroundColor, color, 0.25)
                                      : Colors.transparent,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        tab.iconData,
                                        color: color,
                                      ),
                                      Text(
                                        tab.name,
                                        style: TextStyle(color: color),
                                      ),
                                    ],
                                  ),
                                  // title: Text(page.name),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MaterialButton(
                        color: themeData.scaffoldBackgroundColor,
                        child: Text(isDarkMode ? 'DARK' : 'LIGHT'),
                        onPressed: () => setState(() {
                          themeData = !(isDarkMode = !isDarkMode)
                              ? ThemeData.light().copyWith(primaryColor: themeData.primaryColor)
                              : ThemeData.dark().copyWith(primaryColor: themeData.primaryColor);
                        }),
                      ),
                      MaterialButton(
                        color: themeData.primaryColor,
                        child: Text('#' + themeData.primaryColor.value.toRadixString(16)),
                        onPressed: () => setState(() => themeData = themeData.copyWith(
                              primaryColor: Color.fromRGBO(
                                  Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.scaffoldBackgroundColor,
                    // borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: themeData.primaryColor.withOpacity(0.7),
                        spreadRadius: 1,
                        blurRadius: 2.0,
                        offset: const Offset(-1, -1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: currentTab.builder(context, queries),
                  ),
                ),
              ),
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
    child: const Text("START"),
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
