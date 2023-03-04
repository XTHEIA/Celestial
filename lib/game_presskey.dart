// 키보드빨리누르기?

// 화면에 나오는 키 최대한 빨리 누..르기인데 시간 잴 수 있으려나

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameKeyPress extends StatefulWidget {
  const GameKeyPress({Key? key}) : super(key: key);

  @override
  State<GameKeyPress> createState() => _GameKeyPressState();
}

class _GameKeyPressState extends State<GameKeyPress> {
  static final chars =
      ("`1234567890-=qwertyuiop[]\\asdfghjkl;'zxcvbnm,./~!@#\$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?"
          .characters
          .toList());
  static final charsCount = chars.length;

  _State gameState = _State.READY;

  String key = "?";
  final focusNode = FocusNode(debugLabel: "focus");
  var last = DateTime.now().millisecondsSinceEpoch;
  int lastTook = 0;

  @override
  Widget build(BuildContext context) {
    if (gameState == _State.GAMING) focusNode.requestFocus();

    Widget body;

    switch (gameState) {
      case _State.OVER:
        body = const Text('end');
        break;
      case _State.READY:
        body = const Text("press SPACE to start");
        break;
      case _State.GAMING:
        body = Column(
          children: [
            Text(key),
            Text('last took $lastTook ms'),
            Text('focus : ${focusNode.hasFocus}'),
          ],
        );
        break;
    }

    return KeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      child: body,
      onKeyEvent: (keyEvent) {
        final keyChar = keyEvent.character;
        if (keyChar != null) {
          switch (gameState) {
            case _State.READY:
              if (keyChar == " ") {
                setState(() {
                  gameState = _State.GAMING;
                  key = chars[Random().nextInt(charsCount)];
                  last = DateTime.now().millisecondsSinceEpoch;
                });
              }
              break;
            case _State.GAMING:
              if (key == keyChar) {
                setState(() {
                  key = chars[Random().nextInt(charsCount)];
                  final now = DateTime.now().millisecondsSinceEpoch;
                  final time = now - last;
                  last = now;
                  lastTook = time;
                });
              } else {
                setState(() {
                  gameState = _State.OVER;
                });
              }
              break;
            case _State.OVER:
              // TODO: Handle this case.
              break;
          }
        }
      },
    );
  }
}

enum _State {
  READY,
  GAMING,
  OVER,
}
