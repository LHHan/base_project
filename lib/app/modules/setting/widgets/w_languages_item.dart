import 'package:base_project_getx/app/core/utils/app_style.dart';
import 'package:base_project_getx/app/data/models/languages_model.dart';
import 'package:base_project_getx/app/widgets/w_button_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WLanguagesItem extends StatelessWidget {
  const WLanguagesItem(
      {Key? key,
      required this.language,
      required this.isSelected,
      this.onPressed})
      : super(key: key);

  final Languages language;
  final bool isSelected;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: isSelected
            ? BorderSide(width: 3.r, color: Colors.lightGreen)
            : BorderSide.none,
      ),
      child: WButtonInkwell(
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Flag
            Expanded(
              flex: 3,
              child: SvgPicture.network(
                language.langFlag ?? '',
                fit: BoxFit.cover,
              ),
            ),

            const Divider(height: 0),

            /// Name
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  language.langName ?? '',
                  style: AppStyles().mediumTextStyle(16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
