import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  InputFieldWidget({
    super.key,
    required this.hint,
    required this.label,
    this.leadingIconColor,
    this.leadingIcon,
    this.obscure,
    this.actionIconColor,
    this.actionIcon,
    required this.controller,
    required this.onChanged,
    required this.validator,
  });
  final String hint;
  final String label;
  final Color? leadingIconColor;
  final Widget? leadingIcon;
  final Widget? actionIcon;
  final Color? actionIconColor;
  final bool? obscure;
  final controller;
  final Function onChanged;
  final Function validator;

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: widget.leadingIcon,
        ),
        prefixIconConstraints: BoxConstraints(maxHeight: 26),
        suffixIcon: widget.actionIcon,
        suffixIconColor: widget.actionIconColor,
        iconColor: widget.leadingIconColor,
        hintText: widget.hint,
        labelText: widget.label,
        labelStyle: TextStyle(
          fontFamily: "DM_Sans",
        ),
        hintStyle: TextStyle(
          fontFamily: "DM_Sans",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      obscureText: widget.obscure ?? false,
      onChanged: widget.onChanged(),
      validator: widget.validator(),
    );
  }
}
