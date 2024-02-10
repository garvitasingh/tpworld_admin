import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tpworld_admin/controller/firestore_controller.dart';
import 'package:tpworld_admin/utils/popup.dart';

class NotificationDialog extends StatefulWidget {
  NotificationDialog({Key? key}) : super(key: key);

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>>? profiles;

  Future<void> mainNotification() async {
    CollectionReference collection = firestore.collection('Notifications');
    Map<String, dynamic> notificationData = {
      'notification': _controller.text,
      'read': false,
      'timestamp': DateTime.now().toIso8601String()
    };
    await collection.add(notificationData);
    for (var i = 0; i < profiles!.length; i++) {
      addNotification(profiles![i]['id'], 'Admin Sent New Notification',
          _controller.text, profiles![i]['token']);
    }
    _controller.clear();
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
      pushnotificationapi(
        body,
        token,
      );
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        //height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              color: Color(0xff8ab7f440),
              blurRadius: 5,
              spreadRadius: 0)
        ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  // height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 10,
                    minLines: 1,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                      hintText: "Enter Message",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: mainNotification,
                child: Image.asset(
                  "assets/images/send.png",
                  height: 50,
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _firestoreService.getProfilesStream(),
                  builder: (context, snapshot) {
                    profiles = snapshot.data!;
                    return const Text("");
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('Notifications').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    var data = snapshot.data!.docs;

                    // Sort the data list based on the timestamp
                    data.sort((a, b) => DateTime.parse(b['timestamp'])
                        .compareTo(DateTime.parse(a['timestamp'])));

                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 2,
                      ),
                      itemCount:
                          data.length, // Replace with actual notification count
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime dateTime =
                            DateTime.parse(data[index]['timestamp']);
                        var document = data[index];
                        var documentId = document.id;
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xffF8F8FA),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                70,
                                        child: Text(
                                          data[index]['notification'],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Color(0xff757575),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          deleteNotification(documentId);
                                        },
                                        child: Image.asset(
                                          "assets/images/delete.png",
                                          height: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${formatDate(data[index]['timestamp'])} ${formatTime(dateTime)}',
                                        style: const TextStyle(
                                            color: Color(0xff8a8a8a),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  deleteAllNotifications();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Delete All",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    // Format the time using HH:mm:ss format
    String formattedTime =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return formattedTime;
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    CollectionReference collection = firestore.collection('Notifications');
    await collection.doc(notificationId).update({'read': true});
  }

  Future<void> deleteAllNotifications() async {
    CollectionReference collection = firestore.collection('Notifications');
    await collection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Notifications');
    await collection.doc(notificationId).delete();
  }

  String formatDate(String timestampString) {
    DateTime date = DateTime.parse(timestampString);
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime dayBeforeYesterday = DateTime(now.year, now.month, now.day - 2);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'yes';
    } else if (date.year == dayBeforeYesterday.year &&
        date.month == dayBeforeYesterday.month &&
        date.day == dayBeforeYesterday.day) {
      return 'day before yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  // String formatTime(DateTime dateTime) {
  //   String hour = dateTime.hour.toString().padLeft(2, '0');
  //   String minute = dateTime.minute.toString().padLeft(2, '0');
  //   return '$hour:$minute';
  // }

  String formatTimeFromTimestamp(Timestamp timestamp) {
    DateTime dateTime =
        timestamp.toDate(); // Convert Firestore Timestamp to DateTime
    return formatTime(dateTime);
  }

  pushnotificationapi(body, token) async {
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
        "title": "Admin Sent New Notification",
        "body": body.toString(),
        "color": '#00FF00',
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
