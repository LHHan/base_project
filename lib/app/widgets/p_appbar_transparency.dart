import 'package:base_project_getx/app/widgets/p_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PAppbarTransparency extends StatelessWidget {
  final Widget? child;
  final Widget? body;
  final Color? forceBackgroundColor;

  const PAppbarTransparency({
    super.key,
    this.child,
    this.body,
    this.forceBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return PMaterial(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: child ??
            Scaffold(
              backgroundColor: forceBackgroundColor,
              body: body,
            ),
      ),
    );
  }
}
