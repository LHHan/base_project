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
            MaterialStateProperty.all<Color>(color ?? Colors.transparent),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          final Color sColor = splashColor ?? Colors.grey.withAlpha(100);
          if (states.contains(MaterialState.hovered)) {
            return sColor;
          }
          if (states.contains(MaterialState.pressed)) {
            return sColor;
          }
          return null; // Defer to the widget's default.
        }),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize:
            MaterialStateProperty.all(minimumSize ?? const Size(64, 36)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
