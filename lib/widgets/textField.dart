import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  InputFieldWidget({
    super.key,
    required this.hint,
    this.label,
    this.leadingIconColor,
    this.leadingIcon,
    this.obscure,
    this.actionIconColor,
    this.actionIcon,
    required this.controller,
    this.onTap,
    this.onChanged,
    this.validator,
    this.keyboard,
    this.read,
    this.width,
  });
  final String hint;
  final String? label;
  final Color? leadingIconColor;
  final Widget? leadingIcon;
  final Widget? actionIcon;
  final Color? actionIconColor;
  final bool? obscure;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final Function? onChanged;
  final Function? validator;
  final Function? onTap;
  final bool? read;
  final double? width;

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          readOnly: widget.read ?? false,
          keyboardType: widget.keyboard,
          onTap: () => widget.onTap == null ? {} : widget.onTap!(),
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12),
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
          onChanged: (value) => widget.onChanged ?? {},
          validator: (value) =>
              widget.validator == null ? '' : widget.validator!(value)),
    );
  }
}
