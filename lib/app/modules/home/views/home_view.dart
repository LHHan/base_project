import 'package:base_project_getx/app/core/utils/app_config.dart';
import 'package:base_project_getx/app/core/utils/app_log.dart';
import 'package:base_project_getx/app/core/values/app_enum.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                AppConfig.I.env.envType == EnvType.dev ? 'DEV' : 'PROD',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Card(
              elevation: 4,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text("Change Theme Mode"),
                    ),
                    GetBuilder(
                      id: 'ChangeThemeMode',
                      init: controller,
                      builder: (control) {
                        return IconButton(
                          onPressed: () => controller.onChangeAppTheme(),
                          icon: Icon(
                            Icons.lightbulb,
                            color:
                                controller.isDark ? Colors.grey : Colors.yellow,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
