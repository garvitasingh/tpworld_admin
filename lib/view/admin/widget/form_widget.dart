// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpworld_admin/utils/popup.dart';

import '../../../utils/colors.dart';
import 'custom_textfield_widget.dart';
import 'package:http/http.dart' as http;

class AddCallDialog extends StatefulWidget {
  final TextEditingController notecontroller;
  final TextEditingController pricecontroller;
  final TextEditingController qtycontroller;
  List totlusers;
  final TextEditingController target1controller;
  final TextEditingController target2controller;
  final TextEditingController stoplosscontroller;
  final TextEditingController typecallcontroller;
  AddCallDialog(
      {super.key,
      required this.notecontroller,
      required this.totlusers,
      required this.pricecontroller,
      required this.qtycontroller,
      required this.target1controller,
      required this.target2controller,
      required this.stoplosscontroller,
      required this.typecallcontroller});

  @override
  State<AddCallDialog> createState() => _AddCallDialogState();
}

class _AddCallDialogState extends State<AddCallDialog> {
  final List<String> dropdownValues = ['SELL', 'BUY'];

  String? selectedValue = "SELL";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
          border: Border.all(color: BLUE400_COLOR, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 10.0),
                const Text(
                  "Add Call",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20.0),
                CustomTextFieldWidget(
                    textInputType: false,
                    controller: widget.notecontroller,
                    label: "Enter Calll"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 120,
                  child: CustomTextFieldWidget(
                      textInputType: true,
                      controller: widget.pricecontroller,
                      label: "Price"),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 120,
                  child: CustomTextFieldWidget(
                      textInputType: true,
                      controller: widget.qtycontroller,
                      label: "QTY"),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFieldWidget(
                    textInputType: true,
                    controller: widget.target1controller,
                    label: "Target-1"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFieldWidget(
                    textInputType: true,
                    controller: widget.target2controller,
                    label: "Target-2"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFieldWidget(
                    textInputType: true,
                    controller: widget.stoplosscontroller,
                    label: "STOP-LOSS"),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: widget.typecallcontroller,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: "SELECT TYPE",
                      enabled: true,
                      suffixIcon: DropdownButton<String>(
                        padding: const EdgeInsets.all(12),
                        isExpanded: true,
                        underline: const Text(''),
                        hint: const Text("BUY CALL"),
                        value: selectedValue,
                        items: dropdownValues.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text("$value CALL"),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          // When dropdown value changes
                          setState(() {
                            widget.typecallcontroller.text = newValue!;
                            selectedValue = newValue;
                          });
                        },
                      ),
                      prefixStyle: const TextStyle(fontSize: 16),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: GREY_L_COLOR))),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Color(0x234ACA36),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ]),
                  child: MaterialButton(
                    height: 50,
                    onPressed: () {
                      _addCall();
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color(0xff4ACA36), width: 2),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      "Add Call",
                      style: TextStyle(
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
      ),
    );
  }

  Future<void> _addCall() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection('Calls');
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd/MM/yyyy hh:mma').format(now);

    Set<String> uniqueUserIds = {};
    Set<String> notifications = {};
    int qyt = int.parse(widget.qtycontroller.text.toString());
    int price = int.parse(widget.pricecontroller.text.toString());
    int investment = qyt * price;
    int loss = int.parse(widget.stoplosscontroller.text.toString());
    int profit = 0;
    // int stoploss = investment - (qyt * loss);

    await collection.doc().set({
      'Note': widget.notecontroller.text,
      'target1': widget.target1controller.text.toString(),
      'target2': widget.target2controller.text.toString(),
      'quantity': widget.qtycontroller.text.toString(),
      'investment': investment.toString(),
      'calltype': widget.typecallcontroller.text,
      'profilt': profit.toString(),
      'stop_loss': loss.toString(),
      'price': price.toString(),
      'target1update': false,
      'target2update': false,
      'stoplossupdate': false,
      'userids': uniqueUserIds,
      'notifications': notifications,
      'notificationhide': false,
      'timestamp': now,
      'datetime': formattedDateTime,
    });
    Navigator.pop(context);
    showSuccessSnackBar(context, "${widget.typecallcontroller.text} Added!");
    _sendnotificationtousers(widget.totlusers, widget.notecontroller.text,
        price, widget.typecallcontroller.text);
    widget.notecontroller.clear();
    widget.pricecontroller.clear();
    widget.qtycontroller.clear();
    widget.target1controller.clear();
    widget.target2controller.clear();
    widget.stoplosscontroller.clear();
    widget.typecallcontroller.clear();

    // Add "buy_call" document
  }

  Future<void> _sendnotificationtousers(
      List totlusers, documentName, price, calltype) async {
    for (int i = 0; i < totlusers.length; i++) {
      pushnotificationapi(documentName, price, totlusers[i]['token'], calltype);
      addNotification(totlusers[i]['id'], documentName, "New Call Added!",
          totlusers[i]['token'], calltype, price);
    }
  }

  Future<void> addNotification(String userId, String title, String body,
      String token, calltype, price) async {
    try {
      // Create a new notification object
      Map<String, dynamic> notification = {
        'title': 'Admin added new Call',
        'body': "$calltype $title @$price",
        'time': DateTime
            .now(), // You can also store the timestamp of the notification
        'isRead': false, // Initially set the notification as unread
      };

      // Get the user document and update the notifications array
      await firestore.collection('users').doc(userId).update({
        'notifications': FieldValue.arrayUnion([notification]),
      });
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  pushnotificationapi(title, price, token, calltype) async {
    var headers = {
      'Authorization': 'key=$ServerKEY',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": token,
      "priority": "high",
      "notification": {
        "title": 'Admin Sent New Call to you',
        "body": "$calltype $title @$price",
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
