import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpworld_admin/controller/firestore_controller.dart';

import 'admin_banners.dart';
import 'widget/notification_dialog.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

int inde = -1;
int? userslength;

final FirestoreService _firestoreService = FirestoreService();

final FirebaseAuth _auth = FirebaseAuth.instance;

class _UsersListViewState extends State<UsersListView> {
  @override
  Widget build(BuildContext context) {
    _firestoreService.getUserProfile(_auth.currentUser!.uid);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(70.0), // here the desired height
            child: AppBar(
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              backgroundColor: const Color(0xff334D8F),
              title: Row(
                children: [
                  Image.asset(
                    "assets/images/avatar.png",
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Admin",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "+91 9663000773",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  )
                ],
              ),
              actions: [
                InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: Image.asset(
                        "assets/images/notify.png",
                        height: 25,
                        width: 25,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          barrierColor: Colors.transparent,
                          barrierLabel: "fff",
                          context: context,
                          builder: (BuildContext context) {
                            return const NotificationDialog();
                          });
                    })
              ],
            )),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Users List (${userslength})",
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 100,
                ),
                Expanded(
                    child: TextFormField(
                  decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      hintText: "Search User"),
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _firestoreService.getAllProfiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return const SizedBox();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No Users found.');
              } else {
                List<Map<String, dynamic>> profiles = snapshot.data!;
                userslength = profiles.length;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminBannersView()));
                      },
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/avatar.png",
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          profiles[index]['name'].toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text(
                          profiles[index]['phone'].toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      inde = index;
                                    });
                                  },
                                  icon: Icon(
                                    inde == index
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.red,
                                  )),
                              Image.asset(
                                "assets/images/delete.png",
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ]));
  }

  void _showTopDialog(BuildContext context) {
    showDialog(
        barrierColor: Colors.transparent,
        barrierLabel: "fff",
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actionsAlignment: MainAxisAlignment.start,
            alignment: Alignment.topRight,
            content: Container(
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Notification'), Icon(Icons.close)],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
