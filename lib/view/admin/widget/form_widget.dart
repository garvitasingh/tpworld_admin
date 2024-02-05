import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import 'custom_textfield_widget.dart';

class FormDialogView extends StatelessWidget {
  FormDialogView({super.key, required this.text});
  String text;

  TextEditingController notecontroller = TextEditingController();
  TextEditingController target1controller = TextEditingController();
  TextEditingController target2controller = TextEditingController();
  TextEditingController stoplosscontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: 0.0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.blue),
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          border:Border.all(color: BLUE400_COLOR,width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 10.0),
              Text("Add Call",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),),
              const SizedBox(height: 20.0),
              CustomTextFieldWidget(
                  controller: notecontroller, label: "Enter Note"),
              const SizedBox(
                height: 10,
              ),
              CustomTextFieldWidget(controller: target1controller, label: "target-1"),
              const SizedBox(
                height: 10,
              ),
              CustomTextFieldWidget(controller: target2controller, label: "target-2"),
              const SizedBox(
                height: 10,
              ),
              CustomTextFieldWidget(controller: stoplosscontroller, label: "STOP-LOSS"),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                    boxShadow: [
                    BoxShadow(
                      color:
                      Color(0x234ACA36),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )]
                ),
                child: MaterialButton(
                  height: 50,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xff4ACA36),width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xff4ACA36),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
