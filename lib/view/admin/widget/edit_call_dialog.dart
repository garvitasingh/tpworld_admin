// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpworld_admin/utils/popup.dart';
import 'package:http/http.dart' as http;
import '../../../utils/colors.dart';
import 'custom_textfield_widget.dart';

class EditCallDialog extends StatefulWidget {
  final TextEditingController notecontroller;
  final TextEditingController pricecontroller;
  final TextEditingController qtycontroller;
  final TextEditingController target1controller;
  final TextEditingController target2controller;
  final TextEditingController stoplosscontroller;
  final TextEditingController typecallcontroller;
  List totlusers;
  String id;
  EditCallDialog(
      {super.key,
      required this.notecontroller,
      required this.pricecontroller,
      required this.totlusers,
      required this.qtycontroller,
      required this.target1controller,
      required this.target2controller,
      required this.stoplosscontroller,
      required this.id,
      required this.typecallcontroller});

  @override
  State<EditCallDialog> createState() => _EditCallDialogState();
}

class _EditCallDialogState extends State<EditCallDialog> {
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
                            child: Text("${value} CALL"),
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
                      _editCall(widget.id);
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color(0xff4ACA36), width: 2),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      "Edit Call",
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

  Future<void> _editCall(id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection('Calls');
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd/MM/yyyy hh:mma').format(now);
    DocumentSnapshot documentSnapshot = await collection.doc(id).get();
    dynamic data = documentSnapshot.data();
    int qyt = int.parse(widget.qtycontroller.text.toString());
    int price = int.parse(widget.pricecontroller.text.toString());
    int investment = qyt * price;
    int loss = int.parse(widget.stoplosscontroller.text.toString());
    int profit = int.parse(data['profilt'].toString());
    // int stoploss = investment - (qyt * loss);
    //  await collection.doc(id).update({
    //         'target2update': true,
    //         'profilt': profit,
    //         'target2': tar.toString()
    //       });

    await collection.doc(id).update({
      'Note': widget.notecontroller.text.toString(),
      'target1': data['target1update'] == true
          ? data['target1'].toString()
          : widget.target1controller.text.toString(),
      'target2': data['target2update'] == true
          ? data['target2'].toString()
          : widget.target2controller.text.toString(),
      'quantity': widget.qtycontroller.text.toString(),
      'investment': investment.toString(),
      'calltype': widget.typecallcontroller.text.isEmpty
          ? data['calltype'].toString()
          : widget.typecallcontroller.text,
      'profilt': profit.toString(),
      'stop_loss': data['stoplossupdate'] == true
          ? data['stop_loss'].toString()
          : loss.toString(),
      'price': price.toString(),
      'timestamp': now,
      'datetime': formattedDateTime,
    });
    Navigator.pop(context);
    showSuccessSnackBar(context, "${widget.typecallcontroller.text} Edited!");
    _sendnotificationtousers(widget.totlusers, widget.notecontroller.text);
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
    List totlusers,
    documentName,
  ) async {
    for (int i = 0; i < totlusers.length; i++) {
      pushnotificationapi(documentName, totlusers[i]['token']);
      addNotification(totlusers[i]['id'], documentName, "Call Edited!",
          totlusers[i]['token']);
    }
  }

  Future<void> addNotification(
      String userId, String title, String body, String token) async {
    try {
      // Create a new notification object
      Map<String, dynamic> notification = {
        'title': title,
        'body': body,
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

  pushnotificationapi(title, token) async {
    var headers = {
      'Authorization':
          'key=$ServerKEY',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": token,
      "priority": "high",
      "notification": {
        "title": title,
        "body": "Edited!",
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
