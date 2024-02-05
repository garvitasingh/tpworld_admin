import 'package:flutter/material.dart';
import 'package:tpworld_admin/utils/colors.dart';

import 'custom_textfield_widget.dart';

class AmountDialogView extends StatelessWidget {
  AmountDialogView({super.key, required this.text});
  String text;

  TextEditingController amountController = TextEditingController();

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
              Text("SAMPLE TEXT FROM ADMIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.center,
                child: Text("TARGET-1 HIT",
                  style: TextStyle(
                    color: GREEN_COLOR,
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                  ),),
              ),
              const SizedBox(height: 20.0),
              CustomTextFieldWidget(
                  controller: amountController, label: "Enter Amount"),
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
