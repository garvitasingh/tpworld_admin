import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isSuffix;
  final bool textInputType;

  const CustomTextFieldWidget(
      {Key? key,
      required this.controller,
      required this.label,
      this.isSuffix = false,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType ? TextInputType.phone : TextInputType.name,
      controller: controller,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
          labelText: label,
          enabled: true,
          prefixText: isSuffix ? '+91 ' : "",
          prefixStyle: TextStyle(fontSize: 16),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: GREY_L_COLOR))),
    );
  }
}
