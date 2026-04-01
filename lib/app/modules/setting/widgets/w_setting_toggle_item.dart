import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WSettingToggleItem extends StatelessWidget {
  const WSettingToggleItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subTitle,
    this.leading,
  });

  final String title;
  final String? subTitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: Get.textTheme.tsTitle),
      leading: leading,
      subtitle: subTitle != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(subTitle!, style: Get.textTheme.tsSubTitle),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
