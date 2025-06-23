import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final double height;
  final double? width;
  final TextInputType textInputType;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChanged;
  final Color bgColor;
  final Color? labelColor;
  final Color? textColor;
  final String hint;
  final bool isDense;
  final bool isPassword;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final dynamic maxLines;
  final dynamic minLines;
  final FormFieldValidator<String>? validator;
  final String label;
  final String counterText;
  final bool? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? suffixIconPressed;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final FloatingLabelBehavior floatingLabelBehavior;
  final Color floatingLabelColor;
  final bool isClickable;
  final bool expands;
  final bool hasCode;
  final EdgeInsetsGeometry? textPadding;
  final String? prefixImage;
  final void Function()? onEditingComplete;
  final bool? changePhoneNumber;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.height = 59,
    this.width,
    this.maxLines = 1,
    required this.textInputType,
    this.onSubmit,
    this.onChanged,
    this.validator,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconPressed,
    this.inputFormatters,
    this.isPassword = false,
    this.isClickable = true,
    this.hint = '',
    this.counterText = '',
    this.onTap,
    this.isDense = true,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.bgColor = AppColor.backGroundColor,
    this.labelColor,
    this.focusNode,
    this.maxLength,
    this.margin,
    this.contentPadding,
    this.floatingLabelColor = AppColor.primaryColor,
    this.textColor = Colors.black,
    this.expands = false,
    this.hasCode = false,
    this.textPadding,
    this.prefixImage,
    this.minLines,
    this.onEditingComplete,
    this.changePhoneNumber = false,
  });

  @override
  State<CustomTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode myFocusNode;
  int lengthCounter = 0;

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: SizedBox(
        height: widget.height.h,
        child: TextFormField(
          onEditingComplete: widget.onEditingComplete,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: TextStyle(
            color: widget.textColor,
          ),
          cursorColor: AppColor.secondaryColor,
          controller: widget.controller,
          focusNode: widget.focusNode,
          maxLines: widget.expands ? null : widget.maxLines,
          minLines: widget.expands ? null : widget.minLines,
          expands: widget.expands,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            filled: true,
            counterText: widget.maxLength != null
                ? '$lengthCounter/${widget.maxLength}'
                : '',
            fillColor: widget.bgColor,
            hintText: widget.hint,
            hintStyle: AppStyle.font15_500Weight.copyWith(
              color: AppColor.hintColor,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon != null && widget.prefixIcon == true
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      Image.asset(
                        widget.prefixImage!,
                        fit: BoxFit.cover,
                        height: 24.h,
                      ),
                    ],
                  )
                : null,
            isDense: widget.isDense,
            contentPadding: widget.isDense
                ? EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 12.w,
                  )
                : widget.contentPadding,
            border: AppStyle.borderDone(),
            disabledBorder: AppStyle.borderDone(),
            enabledBorder: AppStyle.borderDone(),
            errorBorder: AppStyle.borderError(context),
            focusedBorder: AppStyle.borderFocuse(),
          ),
          onFieldSubmitted: widget.onSubmit,
          onChanged: widget.maxLength != null ? (value) {} : widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.textInputType,
          obscureText: widget.isPassword,
          enabled: widget.isClickable,
        ),
      ),
    );
  }
}
