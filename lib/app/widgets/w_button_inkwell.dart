import 'package:flutter/material.dart';

class WButtonInkwell extends StatelessWidget {
  const WButtonInkwell({
    Key? key,
    required this.child,
    required this.onPressed,
    this.splashColor,
    this.borderRadius = BorderRadius.zero,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  final Widget child;
  final Function()? onPressed;
  final Color? splashColor;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: splashColor ??
            Theme.of(context).primaryColor.withValues(alpha: 0.3),
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
