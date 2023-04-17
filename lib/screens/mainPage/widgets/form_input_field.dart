import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FormInputField extends StatefulWidget {
  FormInputField(
      {super.key,
      controller,
      keyboardType,
      hintText,
      deviceWidth,
      onTap,
      readOnly,
      onTapOutside,
      focusNode})
      : _controller = controller,
        this.keyboardType = keyboardType,
        this.hintText = hintText,
        this._deviceWidth = deviceWidth,
        this.onTap = onTap,
        this.readOnly = readOnly,
        this.onTapOutside = onTapOutside,
        this.focusNode = focusNode;
  final TextEditingController _controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final double _deviceWidth;
  final Function? onTap;
  final bool? readOnly;
  final Function? onTapOutside;
  final FocusNode? focusNode;

  @override
  State<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 40,
      width: widget._deviceWidth * 0.35,
      child: TextFormField(
        focusNode: widget.focusNode ?? FocusNode(),
        readOnly: widget.readOnly ?? false,
        onTap: () => widget.onTap == null ? {} : widget.onTap!(),
        controller: widget._controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          contentPadding: context.locale == Locale('en')
              ? EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  left: 10.0,
                )
              : EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  right: 10.0,
                ),
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(
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
