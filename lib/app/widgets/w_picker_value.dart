import 'package:base_project_getx/app/core/utils/app_style.dart';
import 'package:base_project_getx/app/widgets/w_button_inkwell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Use: final int index = await WPickerValue.showPicker(context, initialIndex: 0, initValues: <String>[]);

class WPickerValue extends StatefulWidget {
  const WPickerValue({Key? key, this.initialIndex, this.initValues})
      : super(key: key);

  final int? initialIndex;
  final List<String>? initValues;

  static Future<int?> showPicker(BuildContext context,
      {int initialIndex = 0, List<String>? initValues}) {
    return showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          return WPickerValue(
            initialIndex: initialIndex,
            initValues: initValues,
          );
        });
  }

  @override
  State<WPickerValue> createState() => _WPickerValueState();
}

class _WPickerValueState extends State<WPickerValue> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget>? children = widget.initValues == null
        ? <Widget>[]
        : widget.initValues
            ?.map(
              (String e) => Container(
                alignment: Alignment.center,
                child: Text(e,
                    style: AppStyles().normalTextStyle(
                      20.sp,
                      color: Colors.black,
                    )),
              ),
            )
            .toList();
    const double itemExtent = 50;
    final double height = (children?.isNotEmpty ?? false)
        ? ((children?.length ?? 0) * itemExtent)
        : itemExtent;

    return Column(
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            'Pick a value',
            style: AppStyles().normalTextStyle(
              17.sp,
              color: const Color(0xFF8F8F8F),
            ),
          ),
        ),
        SizedBox(
          height: height,
          child: CupertinoPicker(
            onSelectedItemChanged: (int index) {
              HapticFeedback.selectionClick();
              setState(() {
                selected = index;
              });
            },
            itemExtent: itemExtent,
            scrollController: FixedExtentScrollController(
                initialItem: widget.initialIndex ?? 0),
            children: children ?? <Widget>[],
          ),
        ),
        WButtonInkwell(
          child: Container(
            height: 57,
            alignment: Alignment.center,
            child: Text(
              'Confirm',
              style: AppStyles().mediumTextStyle(
                17.sp,
                color: const Color(0xFF0080FA),
              ),
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
