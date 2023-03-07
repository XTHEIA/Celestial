import 'package:celestial/game/game.dart';
import 'package:celestial/game/game_hidden.dart';
import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
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
          Text('$gamesCount개의 게임이 있습니다.'),
          Expanded(
            child: ListView.builder(
              itemCount: gamesCount + 500,
              itemBuilder: (ctx, idx) {
                if (idx >= gamesCount) {
                  final hidden = idx == 150;
                  return ListTile(
                    leading: const FlutterLogo(),
                    title: Text('empty game $idx'),
                    subtitle: Text('subtitle'),
                    onTap: hidden
                        ? () => Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => const GameHidden()))
                        : () => ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        showCloseIcon: true,
                        content: Text('no game!'),
                        duration: Duration(milliseconds: 650),
                      ),
                    ),
                  );
                }
                final game = games[idx];
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