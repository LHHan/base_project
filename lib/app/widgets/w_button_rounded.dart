import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WButtonRounded extends StatelessWidget {
  const WButtonRounded({
    Key? key,
    required this.child,
    this.radius = 8.0,
    required this.onPressed,
    this.background,
    this.splashColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.minimumSize = const Size(64, 36),
  }) : super(key: key);

  final Widget child;
  final double radius;
  final VoidCallback onPressed;
  final Color? background;
  final Color? splashColor;
  final Color? borderColor;
  final double borderWidth;
  final double? elevation;
  final EdgeInsets padding;
  final Size minimumSize;

  Color? _getOverlayColor(Set<WidgetState> states) {
    final Color sColor =
        splashColor ?? Get.theme.colorScheme.secondary.withAlpha(100);
    if (states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.pressed)) {
      return sColor;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            background ?? Get.theme.colorScheme.primary),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(_getOverlayColor),
        elevation: WidgetStateProperty.all(elevation),
        padding: WidgetStateProperty.all(padding),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        minimumSize: WidgetStateProperty.all(minimumSize),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
