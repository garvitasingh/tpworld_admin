import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isSuffix;

  const CustomTextFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.isSuffix = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: 16
      ),
      decoration: InputDecoration(
          labelText: label,
          enabled: true,
          prefixText: isSuffix?'+91 ':"",
          prefixStyle:  TextStyle(
              fontSize: 16
          ),
          border: OutlineInputBorder(borderSide: BorderSide(
            color: GREY_L_COLOR
          ))
      ),
    );
  }
}