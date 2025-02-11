import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';

class WButtonRounded extends StatelessWidget {
  const WButtonRounded({
    Key? key,
    this.child,
    this.radius,
    this.onPressed,
    this.background,
    this.splashColor,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.minimumSize,
  }) : super(key: key);

  final Widget? child;
  final double? radius;
  final Function()? onPressed;
  final Color? background;
  final Color? splashColor;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? padding;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            background ?? AppColors().colorPrimary),
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
        padding: WidgetStateProperty.all(padding ?? EdgeInsets.zero),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 1.0),
          borderRadius: BorderRadius.circular(radius ?? 50),
        )),
        minimumSize:
            WidgetStateProperty.all(minimumSize ?? const Size(64, 36)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
