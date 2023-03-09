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

  Widget _getGameCard(BuildContext context, Game game) {
    final isTarget = game == targetGame;
    _PageState? thisGameCardState;
    if (isTarget) {
      thisGameCardState = pageState;
    }

    final isSelected = thisGameCardState == _PageState.selected_game;
    final isPlaying = thisGameCardState == _PageState.play_game;
    final isExpanded = thisGameCardState == _PageState.expanding_game;

    late double height;
    switch (thisGameCardState) {
      case _PageState.listing_games:
      case null:
        height = 140;
        break;
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

    // 마우스 :
    //  호버 : 정보 보기
    //  클릭 : 선택, 플레이 버튼 표시
    //  플레이 버튼 : 플레이

    // 터치 :
    //  터치 : 선택, 플레이 버튼 표시
    //  꾹 : 정보 보기
    //  플레이 버튼 : 플레이

    onTap() {
      if (thisGameCardState != _PageState.play_game) {
        _selectGameCard(game);
      }
    }

    _hoverOrLongPress() {
      bool otherCardActive = false;
      if (targetGame != null && game != targetGame) {
        otherCardActive = true;
      }

      if ((!otherCardActive) && targetGame != game) {
        _expandGameCard(game);
      }
    }

    onHoverEnter(e) => _hoverOrLongPress();
    onLongPress() => _hoverOrLongPress();

    onPlay() {
      _selectGameCard(game);
      Navigator.push(
          context,
          PageRouteBuilder(
            fullscreenDialog: false,
            pageBuilder: (ctx, a1, a2) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
              ),
              body: game.scene.call(ctx),
            ),
            transitionsBuilder: (ctx, a1, a2, child) {
              final tween = Tween(begin: const Offset(1.0, 0), end: Offset.zero);
              final curvedAnimation = CurvedAnimation(parent: a1, curve: Curves.easeInOutQuart);
              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            },
          ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOutCirc,
          height: height,
          child: Card(
            borderOnForeground: true,
            elevation: isTarget ? 5 : 3,
            shadowColor: Colors.grey,
            color: isSelected ? Colors.orange.shade50 : Colors.white,
            child: MouseRegion(
              onEnter: onHoverEnter,
              onExit: (e) {
                if (thisGameCardState == _PageState.expanding_game) {
                  _unsetGameCard();
                }
              },
              child: InkWell(
                splashColor: Colors.orange.shade200,
                enableFeedback: true,
                excludeFromSemantics: true,
                hoverColor: Colors.transparent,
                onTap: onTap,
                onLongPress: onLongPress,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ],
                              ),
                              (isSelected || isPlaying)
                                  ? IconButton(
                                      color: Colors.orange,
                                      splashRadius: 15,
                                      splashColor: Colors.orange,
                                      onPressed: () {
                                        _unsetGameCard();
                                        _expandGameCard(game);
                                      },
                                      icon: Icon(Icons.close),
                                    )
                                  : const Padding(padding: EdgeInsets.zero),
                            ],
                          ),
                          Text(game.description),
                        ],
                      ),
                      isSelected
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
                                    color: Colors.orange,
                                    onPressed: onPlay,
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
  }

  Widget _gameCardBuilder(BuildContext ctx, int idx) {
    return _getGameCard(ctx, games[idx]);
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
    if (pageState == _PageState.selected_game || pageState == _PageState.play_game) {
      pushURL("?tab=games&selected=${targetGame!.id}");
    }
    // else if (pageState == _PageState.play_game) {
    //   pushURL("?tab=games&play=${targetGame!.id}");
    // }
    else {
      pushURL("?tab=games");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text('$gamesCount개의 게임이 있습니다.'),
        cheat ? const Text('치트가 활성화되었습니다.') : const SizedBox(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: gamesCount,
          itemBuilder: _gameCardBuilder,
        ),
      ],
    );
  }
}
