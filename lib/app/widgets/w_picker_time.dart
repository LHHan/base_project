import 'package:base_project_getx/app/core/utils/app_style.dart';
import 'package:base_project_getx/app/widgets/w_button_inkwell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Use: final Duration duration = await WPickerDate.showPicker(context);

class WPickerTime extends StatefulWidget {
  const WPickerTime({Key? key, this.initDuration}) : super(key: key);

  final Duration? initDuration;

  static Future<Duration?> showPicker(BuildContext context,
      {Duration? initDuration}) {
    return showCupertinoModalPopup<Duration>(
        context: context,
        builder: (BuildContext context) {
          return WPickerTime(
            initDuration: initDuration,
          );
        });
  }

  @override
  State<WPickerTime> createState() => _WPickerTimeState();
}

class _WPickerTimeState extends State<WPickerTime> {
  Duration selected = const Duration(minutes: 1);

  @override
  Widget build(BuildContext context) {
    final bool isTimeValid = selected > Duration.zero;
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            'Pick a duration',
            style: AppStyles()
                .normalTextStyle(17.sp, color: const Color(0xFF8F8F8F)),
          ),
        ),
        SizedBox(
          height: 200,
          child: CupertinoTimerPicker(
            initialTimerDuration: widget.initDuration ?? selected,
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (Duration value) {
              HapticFeedback.selectionClick();
              setState(() {
                selected = value;
              });
            },
          ),
        ),
        WButtonInkwell(
          onPressed: isTimeValid
              ? () {
                  Navigator.of(context).pop(selected);
                }
              : null,
          child: Container(
            height: 57,
            alignment: Alignment.center,
            child: Text(
              'Confirm',
              style: AppStyles().normalTextStyle(17.sp,
                  color: const Color(0xFF0080FA)
                      .withValues(alpha: isTimeValid ? 1 : 0.4)),
            ),
          ),
        ),
      ],
    );
  }
}
