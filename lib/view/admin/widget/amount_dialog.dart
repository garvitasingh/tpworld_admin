// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpworld_admin/utils/colors.dart';
import 'package:tpworld_admin/utils/popup.dart';
import 'package:http/http.dart' as http;
import 'custom_textfield_widget.dart';

class AmountDialogView extends StatefulWidget {
  AmountDialogView(
      {super.key,
      required this.text,
      required this.documentId,
      required this.heading,
      required this.amount,
      required this.totlusers,
      required this.users,
      required this.targetvalue});
  String text;
  String amount;
  String heading;
  String documentId;
  String targetvalue;
  List totlusers;
  List users;

  @override
  State<AmountDialogView> createState() => _AmountDialogViewState();
}

class _AmountDialogViewState extends State<AmountDialogView> {
  TextEditingController amountController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    amountController.text = widget.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        elevation: 0.0,
        alignment: Alignment.center,
        backgroundColor: Colors.transparent,
        child: Card(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10.0),
                  Text(
                    widget.heading,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.targetvalue} HIT",
                      style: TextStyle(
                          color: GREEN_COLOR,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFieldWidget(
                      textInputType: true,
                      controller: amountController,
                      label: "Enter Amount"),
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
                        updateTarget(widget.documentId, amountController.text);
                      },
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0xff4ACA36), width: 2),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        widget.text,
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
        ));
  }

  int typevalue = 0;
  updateTarget(id, target) async {
    CollectionReference collection = firestore.collection('Calls');
    DocumentSnapshot documentSnapshot = await collection.doc(id).get();
    if (documentSnapshot.exists) {
      dynamic data = documentSnapshot.data();
      int investment = int.parse(data['investment'].toString());
      int tar = int.parse(target.toString());
      int qyt = int.parse(data['quantity'].toString());
      int pri = int.parse(data['price'].toString());
      int loss = int.parse(data['stop_loss'].toString());
      int profit = (tar * qyt) - investment;
      int stoploss = investment - (qyt * loss);
      typevalue = tar;
      print(typevalue);
      _sendnotificationtousers(
        widget.totlusers,
        widget.users,
        id,
        data['Note'],
        pri,
        profit,
        widget.targetvalue,
      );
      if (data['target1update'].toString() == "false" &&
          widget.targetvalue == "TARGET-1") {
        await collection.doc(id).update({
          'target1update': true,
          'profilt': profit,
          'target1': tar.toString()
        });

        Navigator.pop(context);
        showSuccessSnackBar(context, "Target 1 completed!");
        return;
      }
      if (data['target2update'].toString() == "false" &&
          widget.targetvalue == "TARGET-2") {
        await collection.doc(id).update({
          'target2update': true,
          'profilt': profit,
          'target2': tar.toString()
        });

        Navigator.pop(context);
        showSuccessSnackBar(context, "Target 2 completed!");
        return;
      }
      if (data['stoplossupdate'].toString() == "false") {
        await collection.doc(id).update({
          'stoplossupdate': true,
          'stop_loss': loss.toString(),
          'profilt': stoploss,
        });

        Navigator.pop(context);
        showSuccessSnackBar(context, "Stop Loss completed!");
        return;
      }
    }
  }

  Future<void> _sendnotificationtousers(
    List totlusers,
    List users,
    documentId,
    documentName,
    prise,
    profit,
    notification,
  ) async {
    for (int i = 0; i < totlusers.length; i++) {
      pushnotificationapi(documentName, notification.toString(),
          totlusers[i]['token'], prise, profit);
      addNotification(totlusers[i]['id'], documentName, notification, prise,
          profit, totlusers[i]['token']);
    }
    addNotificationWithId(
        documentId, 'Hit $notification @$typevalue profit: $profit', totlusers);
  }

  Future<void> addNotification(String userId, String title, String body, prise,
      profit, String token) async {
    try {
      var protext = 'profit';
      if (widget.targetvalue == 'TARGET-2' ||
          widget.targetvalue == 'TARGET-1') {
        protext = 'proft';
      } else {
        protext = 'loss';
      }
      // Create a new notification object
      Map<String, dynamic> notification = {
        "title": '$title @$prise',
        "body": "Hit $body @$typevalue $protext: $profit",
        'time': DateTime.now(),
        'isRead': false,
      };

      // Get the user document and update the notifications array
      await firestore.collection('users').doc(userId).update({
        'notifications': FieldValue.arrayUnion([notification]),
      });
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  Future<void> addNotificationWithId(
      String id, String notification, userIds) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('Calls');
      DocumentSnapshot documentSnapshot = await collection.doc(id).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> existingData =
            documentSnapshot.data() as Map<String, dynamic>;

        List<Map<String, dynamic>> existingNotifications =
            List<Map<String, dynamic>>.from(
                existingData['notifications'] ?? []);

        Map<String, bool> usersMap = {};
        for (var userData in userIds) {
          usersMap[userData['id']] = false;
        }
        existingNotifications.add({
          "notification": notification,
          "users": usersMap, // Set the users map in the notification object
        });

        await collection.doc(id).update({
          "notifications": existingNotifications,
        });

        showSuccessSnackBar(context, "Notification Added!");
      } else {}
    } catch (e) {
      print('Error adding notification: $e');

      throw e;
    }
  }

  pushnotificationapi(
    title,
    body,
    token,
    prise,
    profit,
  ) async {
    var headers = {
      'Authorization': 'key=$ServerKEY',
      'Content-Type': 'application/json'
    };
    var protext = 'profit';

    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    if (widget.targetvalue == 'TARGET-2' || widget.targetvalue == 'TARGET-1') {
      protext = 'proft';
    } else {
      protext = 'loss';
    }

    request.body = json.encode({
      "to": token,
      "priority": "high",
      "notification": {
        "title": '$title @$prise',
        "body": "Hit $body @$typevalue $protext: $profit",
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
