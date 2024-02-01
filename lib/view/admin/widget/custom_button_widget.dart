import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;

  CustomButtonWidget({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(BLUE500_COLOR),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
