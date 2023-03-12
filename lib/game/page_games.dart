import 'dart:developer';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:celestial/game/game.dart';
import 'package:celestial/game/game_hidden.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key, this.queries}) : super(key: key);
  final Map<String, String>? queries;

  @override
  State<GamesPage> createState() => _GamesPageState();
}

enum _PageState {
  listing_games,
  expanding_game,
  selected_game,
  play_game,
}

class _GamesPageState extends State<GamesPage> {
  _PageState pageState = _PageState.listing_games;
  Game? targetGame = null;

  void _expandGameCard(Game game) {
    setState(() {
      pageState = _PageState.expanding_game;
      targetGame = game;
    });
  }

  void _playGameCard(Game game) {
    setState(() {
      pageState = _PageState.play_game;
      targetGame = game;
    });
  }

  void _unsetGameCard() {
    setState(() {
      pageState = _PageState.listing_games;
      targetGame = null;
    });
  }

  void _selectGameCard(Game game) {
    setState(() {
      pageState = _PageState.selected_game;
      targetGame = game;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 이게 한 번만 실행되는지 알 수가 없네..
    final queries = widget.queries;
    if (queries != null) {
      final expand = queries["selected"];
      if (expand != null) {
        for (final game in games) {
          if (game.id == expand) {
            targetGame = game;
            pageState = _PageState.selected_game;
          }
        }
      } else {
        final play = queries["play"];
        if (play != null) {
          for (final game in games) {
            if (game.id == play) {
              targetGame = game;
              pageState = _PageState.play_game;
            }
          }
        }
      }
      widget.queries!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final primaryColor = themeData.primaryColor;
    if (pageState == _PageState.selected_game || pageState == _PageState.play_game) {
      pushURL("?tab=games&selected=${targetGame!.id}");
    }
    // else if (pageState == _PageState.play_game) {
    //   pushURL("?tab=games&play=${targetGame!.id}");
    // }
    else {
      pushURL("?tab=games");
    }

    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Text('$gamesCount개의 게임이 있습니다.'),
              ),
            ),
            cheat ? const Text('치트가 활성화되었습니다.') : const SizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: gamesCount,
                itemBuilder: (ctx, idx) {
                  final game = games[idx];

                  final isTarget = game == targetGame;

                  bool isThis(_PageState state) {
                    assert(state != _PageState.listing_games);
                    return isTarget && pageState == state;
                  }

                  late final double height;
                  if (isTarget) {
                    assert(pageState != _PageState.listing_games);
                    switch (pageState) {
                      case _PageState.expanding_game:
                        height = 180;
                        break;
                      case _PageState.selected_game:
                        height = 220;
                        break;
                      case _PageState.play_game:
                        height = 500;
                        break;
                    }
                  } else {
                    height = 100;
                  }

                  // 마우스 :
                  //  호버 : 정보 보기
                  //  클릭 : 선택, 플레이 버튼 표시
                  //  플레이 버튼 : 플레이

                  // 터치 :
                  //  터치 : 선택, 플레이 버튼 표시
                  //  꾹 : 정보 보기
                  //  플레이 버튼 : 플레이

                  peekCard() {
                    bool otherCardActive = false;
                    if (targetGame != null && game != targetGame) {
                      otherCardActive = true;
                    }

                    if ((!otherCardActive) && targetGame != game) {
                      _expandGameCard(game);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                    child: AnimatedContainer(
                        height: height,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOutCirc,
                        child: Card(
                          borderOnForeground: true,
                          elevation: isTarget ? 6 : 3,
                          shadowColor: Color.lerp(themeData.shadowColor, themeData.primaryColor, 0.5),
                          color: isThis(_PageState.selected_game)
                              ? Color.lerp(themeData.scaffoldBackgroundColor, primaryColor, 0.08)
                              : null,
                          child: MouseRegion(
                            onEnter: (e) => peekCard(),
                            onExit: (e) {
                              if (isThis(_PageState.expanding_game)) {
                                _unsetGameCard();
                              }
                            },
                            child: InkWell(
                              enableFeedback: true,
                              excludeFromSemantics: true,
                              hoverColor: Colors.transparent,
                              onTap: () {
                                if (!isThis(_PageState.play_game)) {
                                  _selectGameCard(game);
                                }
                              },
                              onLongPress: () => peekCard(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                // 메인
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // 아이콘 - 이름 - 난이도 - 닫기 버튼
                                    // 설명
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  game.iconData,
                                                  color: primaryColor,
                                                  size: 30,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: game.name + '  ',
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                        ),
                                                        TextSpan(
                                                          text: game.difficulty,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              color: themeData.primaryColor,
                                              splashRadius: 15,
                                              mouseCursor: MouseCursor.defer,
                                              disabledColor: Colors.transparent,
                                              onPressed:
                                                  isThis(_PageState.play_game) || isThis(_PageState.selected_game)
                                                      ? () {
                                                          _unsetGameCard();
                                                          _expandGameCard(game);
                                                        }
                                                      : null,
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(game.description),
                                      ],
                                    ),
                                    // Play 버튼
                                    isThis(_PageState.selected_game)
                                        ? Row(
                                            children: [
                                              // IconButton(
                                              //   onPressed: () {},
                                              //   icon: Icon(Icons.share),
                                              //   padding: EdgeInsets.zero,
                                              // ),
                                              Expanded(
                                                child: MaterialButton(
                                                  elevation: 0,
                                                  splashColor: Colors.transparent,
                                                  color: primaryColor,
                                                  onPressed: () {
                                                    _selectGameCard(game);
                                                    Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          fullscreenDialog: false,
                                                          pageBuilder: (ctx, a1, a2) => Scaffold(
                                                            appBar: AppBar(
                                                              leading: IconButton(
                                                                color: themeData.primaryColor,
                                                                icon: Icon(Icons.close),
                                                                onPressed: () {
                                                                  Navigator.pop(ctx);
                                                                },
                                                              ),
                                                            ),
                                                            body: game.scene(ctx),
                                                          ),
                                                          transitionsBuilder: (ctx, a1, a2, child) {
                                                            final tween =
                                                                Tween(begin: const Offset(1.0, 0), end: Offset.zero);
                                                            final curvedAnimation = CurvedAnimation(
                                                                parent: a1, curve: Curves.easeInOutQuart);
                                                            return SlideTransition(
                                                              position: tween.animate(curvedAnimation),
                                                              child: child,
                                                            );
                                                          },
                                                        ));
                                                  },
                                                  child: Text('play'),
                                                ),
                                              )
                                            ],
                                          )
                                        : SizedBox()
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
      ),
    );
  }
}
