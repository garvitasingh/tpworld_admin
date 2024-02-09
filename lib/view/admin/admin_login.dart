// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tpworld_admin/controller/auth_controller.dart';
import 'package:tpworld_admin/utils/popup.dart';

import 'dashboard.dart';
import 'widget/custom_button_widget.dart';
import 'widget/custom_textfield_widget.dart';

class AdminLoginView extends StatelessWidget {
  AdminLoginView({super.key});
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Container(
                    height: h * 0.3,
                    child: Image.asset("assets/images/signup.png")),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Admin Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldWidget(
                  textInputType: false,
                  controller: _firstController,
                  label: "Email",
                  isSuffix: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldWidget(
                  textInputType: false,
                  controller: _lastController,
                  label: "password",
                  isSuffix: false,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButtonWidget(
                    title: "Login",
                    onPress: () async {
                      if (_firstController.text.isEmpty) {
                        showErrorSnackBar(context, 'Please Enter Email!!');
                      } else if (_lastController.text.isEmpty) {
                        showErrorSnackBar(context, 'Please Enter Password!!');
                      } else {
                        bool signUpSuccess = await signInWithEmailAndPassword(
                            _firstController.text.trim(),
                            _lastController.text.trim(),
                            context);
                        if (signUpSuccess) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DashBoardView(
                                        index: 0,
                                      )));
                        }
                      }

                      // Navigator.popAndPushNamed(context, Routes.home);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => DashBoardView(index: 0,)));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
