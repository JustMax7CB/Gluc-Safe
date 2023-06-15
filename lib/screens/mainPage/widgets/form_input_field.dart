import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FormInputField extends StatefulWidget {
  const FormInputField(
      {super.key,
      controller,
      this.keyboardType,
      this.hintText,
      deviceWidth,
      this.onTap,
      this.readOnly,
      this.onTapOutside,
      this.focusNode,
      this.textAlign,
      this.textStyle,
      required this.deviceHeight})
      : _controller = controller,
        _deviceWidth = deviceWidth;
  final TextEditingController _controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final double _deviceWidth, deviceHeight;
  final Function? onTap;
  final bool? readOnly;
  final Function? onTapOutside;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  @override
  State<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 40,
      width: widget._deviceWidth * 0.35,
      child: TextFormField(
        textAlign: widget.textAlign ?? TextAlign.start,
        focusNode: widget.focusNode ?? FocusNode(),
        readOnly: widget.readOnly ?? false,
        style: widget.textStyle,
        onTap: () => widget.onTap == null ? {} : widget.onTap!(),
        controller: widget._controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          contentPadding: context.locale == const Locale('en')
              ? const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  left: 8.0,
                )
              : const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  right: 8.0,
                ),
          fillColor: Colors.white,
          filled: true,
          hintStyle: const TextStyle(
            fontFamily: "DM_Sans",
            fontSize: 17,
          ),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
