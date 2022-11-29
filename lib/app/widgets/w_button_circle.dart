import 'package:flutter/material.dart';

class WButtonCircle extends StatelessWidget {
  const WButtonCircle(
      {Key? key, this.width, this.onPressed, this.child, this.color})
      : super(key: key);

  final double? width;
  final Function()? onPressed;
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 50,
      height: width ?? 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: color ?? Colors.transparent,
          padding: const EdgeInsets.all(0),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
