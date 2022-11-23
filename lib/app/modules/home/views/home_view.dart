import 'package:base_project_getx/app/core/utils/app_config.dart';
import 'package:base_project_getx/app/core/utils/app_asset.dart';
import 'package:base_project_getx/app/core/utils/app_enum.dart';
import 'package:base_project_getx/app/core/utils/app_style.dart';
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
            Spacer(),
            Center(
              child: Text(
                '${'hello'.tr} ${AppConfig.I.env.envType == EnvType.dev ? 'DEV' : 'PROD'}',
                style: AppStyles().normalTextStyle(20),
              ),
            ),
            Spacer(),

            /// Change App Theme Card
            Card(
              elevation: 4,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(minHeight: 65),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'changeAppTheme'.tr,
                        style: AppStyles().normalTextStyle(18),
                      ),
                    ),
                    GetBuilder(
                      id: 'changeAppTheme',
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
            const SizedBox(height: 50),

            /// Change App Locale Card
            Card(
              elevation: 4,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(minHeight: 65, minWidth: Get.width),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(
                      'changeAppLocale'.tr,
                      style: AppStyles().normalTextStyle(18),
                    ),
                    Positioned(
                      right: -13,
                      child: InkWell(
                        onTap: controller.onChangeAppLocale,
                        borderRadius: BorderRadius.circular(55),
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: GetBuilder(
                            id: 'changeAppLocale',
                            init: controller,
                            builder: (control) => Image.asset(
                              controller.selectedLocale == LocaleCode.en.name
                                  ? AppAssets().imFlagEn
                                  : AppAssets().imFlagVi,
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                      ),
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
