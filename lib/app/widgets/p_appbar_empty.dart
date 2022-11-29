import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../core/utils/app_config.dart';
import 'p_material.dart';

class PAppBarEmpty extends StatelessWidget {
  const PAppBarEmpty({required this.child, this.actionBtn, Key? key})
      : super(key: key);

  final Widget child;
  final Widget? actionBtn;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Get.isDarkMode ? AppConfig.I.theme.dark : AppConfig.I.theme.light;
    return PMaterial(
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: AppBar(
            elevation: 0,
            systemOverlayStyle: Get.isDarkMode
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            backgroundColor: theme.colorScheme.primary,
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: child,
        ),
        floatingActionButton: actionBtn,
      ),
    );
  }
}
