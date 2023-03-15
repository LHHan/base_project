import 'package:base_project_getx/app/core/utils/app_style.dart';
import 'package:base_project_getx/app/widgets/w_button_inkwell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Use: final DateTime dateTime = await WPickerDate.showPicker(context);

class WPickerDate extends StatefulWidget {
  const WPickerDate({Key? key, this.initDateTime}) : super(key: key);

  final DateTime? initDateTime;

  static Future<DateTime?> showPicker(BuildContext context,
      {DateTime? initDateTime}) {
    return showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return WPickerDate(
            initDateTime: initDateTime,
          );
        });
  }

  @override
  State<WPickerDate> createState() => _WPickerDateState();
}

class _WPickerDateState extends State<WPickerDate> {
  DateTime selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            'Pick a time',
            style: AppStyles()
                .normalTextStyle(17.sp, color: const Color(0xFF8F8F8F)),
          ),
        ),
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            initialDateTime: widget.initDateTime ?? selected,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime value) {
              HapticFeedback.selectionClick();
              setState(() {
                selected = value;
              });
            },
          ),
        ),
        WButtonInkwell(
          child: Container(
            height: 57,
            alignment: Alignment.center,
            child: Text(
              'Confirm',
              style: AppStyles()
                  .normalTextStyle(17.sp, color: const Color(0xFF0080FA)),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(selected);
          },
        ),
      ],
    );
  }
}
