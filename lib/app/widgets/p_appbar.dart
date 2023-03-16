import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../core/utils/app_config.dart';
import 'p_material.dart';

class PAppBar extends StatelessWidget {
  const PAppBar({
    Key? key,
    required this.child,
    this.appBarTitle,
    this.appBarLeading,
    this.appBarAction,
    this.drawer,
    this.actionBtn,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  final Widget child;
  final Widget? appBarTitle;
  final Widget? appBarLeading;
  final List<Widget>? appBarAction;
  final Widget? drawer;
  final Widget? actionBtn;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Get.isDarkMode ? AppConfig.I.theme.dark : AppConfig.I.theme.light;
    return PMaterial(
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        drawer: drawer,
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: Get.isDarkMode
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          title: appBarTitle,
          leading: appBarLeading,
          actions: appBarAction,
        ),
        body: SafeArea(
          bottom: false,
          child: child,
        ),
        floatingActionButton: actionBtn,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
