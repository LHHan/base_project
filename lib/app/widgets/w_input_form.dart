import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WInputForm extends StatelessWidget {
  const WInputForm({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureTextNotifier,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.contentPadding,
    this.margin,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorTextColor,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.maxLines = 1,
  });

  const WInputForm.email({
    Key? key,
    this.controller,
    this.labelText = 'Email',
    this.hintText = 'Enter your email',
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureTextNotifier,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.emailAddress,
    this.contentPadding,
    this.margin,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorTextColor,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.maxLines = 1,
  }) : super(key: key);

  const WInputForm.password({
    Key? key,
    this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureTextNotifier,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.visiblePassword,
    this.contentPadding,
    this.margin,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorTextColor,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueNotifier<bool>? obscureTextNotifier;
  final bool readOnly;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Color? errorTextColor;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: obscureTextNotifier ??
            ValueNotifier<bool>(obscureTextNotifier?.value ?? false),
        builder: (context, obscureText, child) {
          return TextFormField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            style: style ?? Get.textTheme.tsBody,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: labelStyle ?? Get.textTheme.tsSubTitle,
              hintText: hintText,
              hintStyle: hintStyle ?? Get.textTheme.tsHint,
              errorText: errorText,
              errorStyle: Get.textTheme.tsBody.copyWith(color: errorTextColor),
              border: border ?? const OutlineInputBorder(),
              focusedBorder: focusedBorder ?? const OutlineInputBorder(),
              errorBorder: errorBorder ?? const OutlineInputBorder(),
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon ??
                  (obscureTextNotifier == null
                      ? null
                      : obscureText
                          ? IconButton(
                              icon: const Icon(Icons.visibility_off),
                              onPressed: () {
                                obscureTextNotifier?.value = !obscureText;
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {
                                obscureTextNotifier?.value = !obscureText;
                              },
                            )),
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            focusNode: focusNode,
            textInputAction: textInputAction,
            readOnly: readOnly,
            maxLines: maxLines,
          );
        },
      ),
    );
  }
}
