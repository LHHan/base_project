import 'package:base_project_getx/app/core/utils/app_config.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text(
              AppConfig.I.env.envType == EnvType.dev ? 'DEV' : 'PROD',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: controller.onPressed,
            onLongPress: controller.onLongPressed,
            child: const Text("Button"),
          ),
        ],
      ),
    );
  }
}
