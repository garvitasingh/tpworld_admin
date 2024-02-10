import 'package:awesome_dialog/awesome_dialog.dart';
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
final TextEditingController _searchController = TextEditingController();

final FirebaseAuth _auth = FirebaseAuth.instance;
String _searchText = '';

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
                            return NotificationDialog();
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
                StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _firestoreService.getProfilesStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Users List is empty!');
                      }
                      List<Map<String, dynamic>> profiles = snapshot.data!;
                      // Filter users based on search text

                      return Text(
                        "Users List (${profiles.length})",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      );
                    }),
                const SizedBox(
                  width: 100,
                ),
                Expanded(
                    child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
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
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firestoreService.getProfilesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No Users found.');
              } else {
                List<Map<String, dynamic>> profiles = snapshot.data!;
                List<Map<String, dynamic>> filteredProfiles =
                    profiles.where((profile) {
                  String name = profile['name'].toString().toLowerCase();
                  String phone = profile['phone'].toString().toLowerCase();
                  return name.contains(_searchText.toLowerCase()) ||
                      phone.contains(_searchText.toLowerCase());
                }).toList();
                userslength = filteredProfiles.length;
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Color(0xff5496EE),
                  ),
                  shrinkWrap: true,
                  itemCount: filteredProfiles.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: filteredProfiles[index]['isdelete'].toString() ==
                              "true"
                          ? SizedBox()
                          : ListTile(
                              minLeadingWidth: 3,
                              leading: filteredProfiles[index]
                                              ['profileImage'] ==
                                          "" ||
                                      filteredProfiles[index]['profileImage'] ==
                                          null
                                  ? const CircleAvatar(
                                      radius: 27,
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 27,
                                      backgroundImage: NetworkImage(
                                          filteredProfiles[index]
                                                  ['profileImage']
                                              .toString()),
                                    ),
                              title: Text(
                                filteredProfiles[index]['name'].toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              subtitle: Stack(
                                children: [
                                  Positioned(
                                    child: Text(
                                      filteredProfiles[index]['phone']
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff00367F),
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  // Positioned(
                                  //     right: filteredProfiles[index]
                                  //             ['phoneVerified']? 45:75,
                                  //     child: filteredProfiles[index]
                                  //             ['phoneVerified']
                                  //         ? Image.asset(
                                  //             "assets/images/tick.png",
                                  //             height: 10,
                                  //           )
                                  //         : Image.asset(
                                  //             "assets/images/tick_light.png",
                                  //             height: 10,
                                  //           ))
                                ],
                              ),
                              trailing: Container(
                                width: 90,
                                child: Row(
                                  children: [
                                    filteredProfiles[index]['isHide']
                                                .toString() ==
                                            "true"
                                        ? IconButton(
                                            onPressed: () {
                                              _firestoreService.isHide(
                                                  filteredProfiles[index]['id']
                                                      .toString(),
                                                  'false');
                                            },
                                            icon: const Icon(
                                              Icons.visibility_off,
                                              color: Colors.red,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              _firestoreService.isHide(
                                                  filteredProfiles[index]['id']
                                                      .toString(),
                                                  'true');
                                            },
                                            icon: const Icon(
                                              Icons.visibility,
                                              color: Colors.green,
                                            )),
                                    InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.question,
                                          animType: AnimType.rightSlide,
                                          title: 'Action',
                                          desc:
                                              'Are you sure want to delete this user?',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            _firestoreService.isDelete(
                                                filteredProfiles[index]['id']
                                                    .toString());
                                          },
                                        ).show();
                                      },
                                      child: Image.asset(
                                        "assets/images/delete.png",
                                        height: 30,
                                      ),
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
