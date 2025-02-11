import 'package:flutter/material.dart';

class WButtonRaisedFlat extends StatelessWidget {
  const WButtonRaisedFlat({
    Key? key,
    this.onPressed,
    this.child,
    this.color,
    this.splashColor,
    this.minimumSize,
  }) : super(key: key);
  final Function()? onPressed;
  final Widget? child;
  final Color? color;
  final Color? splashColor;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(color ?? Colors.transparent),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          final Color sColor = splashColor ?? Colors.grey.withAlpha(100);
          if (states.contains(WidgetState.hovered)) {
            return sColor;
          }
          if (states.contains(WidgetState.pressed)) {
            return sColor;
          }
          return null; // Defer to the widget's default.
        }),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        minimumSize:
            WidgetStateProperty.all(minimumSize ?? const Size(64, 36)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
