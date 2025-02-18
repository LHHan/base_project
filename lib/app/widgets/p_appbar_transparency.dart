import 'package:base_project_getx/app/widgets/p_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PAppbarTransparency extends StatelessWidget {
  final Widget child;
  final Color? forceBackgroundColor;

  const PAppbarTransparency({
    Key? key,
    required this.child,
    this.forceBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PMaterial(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: forceBackgroundColor,
          body: child,
        ),
      ),
    );
  }
}
