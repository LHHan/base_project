import 'package:flutter/material.dart';

class PMaterial extends StatelessWidget {
  const PMaterial({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: child,
    );
  }
}
