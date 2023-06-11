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
    this.validator,
    this.keyboard,
    this.read,
    this.width,
    this.fieldKey,
    this.height,
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
  final Function? validator;
  final Function? onTap;
  final bool? read;
  final double? width;
  final Key? fieldKey;
  final double? height;

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: TextFormField(
          key: widget.fieldKey ?? Key(''),
          readOnly: widget.read ?? false,
          keyboardType: widget.keyboard,
          onTap: () => widget.onTap == null ? {} : widget.onTap!(),
          controller: widget.controller,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget.leadingIcon,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 26),
            suffixIcon: widget.actionIcon,
            hintText: widget.hint,
            labelText: widget.label,
          ),
          obscureText: widget.obscure ?? false,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) =>
              widget.validator == null ? '' : widget.validator!(value)),
    );
  }
}
