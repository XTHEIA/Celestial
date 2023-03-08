import 'dart:developer';

import 'package:celestial/game/game.dart';
import 'package:celestial/game/game_hidden.dart';
import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  String hoverGameID = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text('$gamesCount개의 게임이 있습니다.'),
          cheat ? const Text('치트가 활성화되었습니다.') : const SizedBox(),
          Expanded(
            child: ListView.builder(
              itemCount: gamesCount,
              itemBuilder: (ctx, idx) {
                final game = games[idx];
                final isHover = game.id == hoverGameID;
                ;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      curve: Curves.easeInOutCirc,
                      height: isHover ? 180 : 140,
                      child: Card(
                        borderOnForeground: true,
                        elevation: 8,
                        shadowColor: Colors.orange.shade200,
                        child: MouseRegion(
                          onEnter: (e) => setState(() => hoverGameID = game.id),
                          onExit: (e) => setState(() => hoverGameID = ""),
                          child: InkWell(
                            hoverColor: Colors.orange.shade50,
                            splashColor: Colors.orange.shade200,
                            enableFeedback: true,
                            excludeFromSemantics: true,
                            onTap: () => Navigator.pushNamed(ctx, "/games/${game.id}"),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.add_card_sharp,
                                        color: Colors.orangeAccent,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        game.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  Text(game.description),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
