import 'package:flutter/material.dart';

class Cellophane extends StatelessWidget {
  const Cellophane({super.key, this.onPressed, this.color, this.child});

  final Color? color;
  final void Function()? onPressed;
  final Widget? child;

  @override
  MaterialButton build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 100,
      minWidth: 100,
      color: color,
      highlightColor: color,
      child: child,
    );
  }
}
