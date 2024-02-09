// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpworld_admin/utils/popup.dart';

import 'widget/notification_dialog.dart';

class AdminBannersView extends StatefulWidget {
  const AdminBannersView({super.key});

  @override
  State<AdminBannersView> createState() => _AdminBannersViewState();
}

class _AdminBannersViewState extends State<AdminBannersView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  String? messa = '';
  String? link = ' ';
  File? banner;
  bool upload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0), // here the desired height
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: () {
                _getImage();
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue)),
                width: MediaQuery.of(context).size.width,
                child: upload == true
                    ? image == null
                        ? const Center(
                            child: Text(
                            "Banner Image",
                            style: TextStyle(fontSize: 20),
                          ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ))
                    : const Center(
                        child: Text(
                        "Banner Image",
                        style: TextStyle(fontSize: 20),
                      )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Action',
                      desc: 'Are you sure want to add this banner?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        _uploadbannerImage(image);
                      },
                    ).show();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff4ACA36)),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x234ACA36),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                        "  Add  ",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff4ACA36),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Divider(
              color: Colors.blue,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.blue)),
                        child: TextFormField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              hintText: "Enter Message"),
                        ))),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      messa = _messageController.text;
                    });
                    updatemesaage();
                  },
                  child: Image.asset(
                    "assets/images/send.png",
                    height: 50,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.blue)),
                        child: TextFormField(
                          controller: _linkController,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              hintText: "Enter Link or paste"),
                        ))),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      link = _linkController.text;
                    });
                    updatelink();
                  },
                  child: Image.asset(
                    "assets/images/send.png",
                    height: 50,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<DocumentSnapshot>(
                stream:
                    firestore.collection('Admin').doc('message').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(width: 250, child: Text(data['message'])),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _messageController.text = data['message']!;
                            });
                          },
                          child: const Text(
                            "EDIT",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  );
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: firestore.collection('Admin').doc('link').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                          width: 250, child: Text(data['link'].toString())),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _linkController.text = data['link']!;
                            });
                          },
                          child: const Text(
                            "EDIT",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  );
                }),
            const Divider(
              color: Colors.blue,
            ),
            const Text(
              "Banners List",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('Admin')
                    .doc('announcements')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  dynamic data = snapshot.data!.data()!;
                  List<Map<String, dynamic>> announcements =
                      List.from(data['announcements']);
                  return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: announcements.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 160,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    announcements[index]['banner'],
                                  )),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue)),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await deleteBannerByMessage(
                                            announcements[index]['banner']);
                                      },
                                      child: Image.asset(
                                        "assets/images/delete.png",
                                        height: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }),
          ]),
        ),
      ),
    );
  }

  bool load = false;
  File? image;

  Future _getImage() async {
    final ImagePicker _picker = ImagePicker();
   
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      upload = true;
      image = img != null ? File(img.path) : null;
    });
    print(image);
  }

  Future<void> updateBanner(String image) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Admin');

    Map<String, dynamic> newAnnouncement = {
      'banner': image,
      'timestamp': DateTime.now().toIso8601String(),
    };

    DocumentSnapshot snapshot = await collection.doc("announcements").get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>? ?? {};

    List<dynamic> existingAnnouncements = data.containsKey('announcements')
        ? List.from(data['announcements'])
        : [];

    existingAnnouncements.add(newAnnouncement);

    await collection.doc("announcements").set({
      'announcements': existingAnnouncements,
    });
    setState(() {
       upload = false;
    });
    showSuccessSnackBar(context, "banner added!");
  }

  Future<void> updatemesaage() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Admin');

    await collection.doc("message").set({
      'message': messa,
    });
    _messageController.clear();
    showSuccessSnackBar(context, "message added!");
  }

  Future<void> updatelink() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Admin');

    await collection.doc("link").set({
      'link': link,
    });
    showSuccessSnackBar(context, "Link added!");
    _linkController.clear();
  }

  Future<void> deleteBannerByMessage(String message) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Admin');

    // Get the document containing the list of announcements
    DocumentSnapshot snapshot = await collection.doc("announcements").get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>? ?? {};

    // Check if the document contains the 'announcements' field
    if (data.containsKey('announcements')) {
      List<dynamic> existingAnnouncements = List.from(data['announcements']);

      // Iterate through the list of announcements to find the one with the matching message
      for (int i = 0; i < existingAnnouncements.length; i++) {
        Map<String, dynamic> announcement = existingAnnouncements[i];
        if (announcement.containsKey('banner') &&
            announcement['banner'] == message) {
          // Remove the announcement from the list
          existingAnnouncements.removeAt(i);

          // Update the document in Firestore with the updated list of announcements
          await collection.doc("announcements").update({
            'announcements': existingAnnouncements,
          });

          print('Banner with message "$message" deleted successfully.');
          return;
        }
      }
    }

    // Print a message if no matching banner is found
    print('Banner with message "$message" not found.');
  }

  Future<String?> _uploadbannerImage(File? image) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('${image!.path}/banners.jpg');
      print(storageReference);
      UploadTask uploadTask = storageReference.putFile(File(image.path));

      await uploadTask.whenComplete(() => print('Banner uploaded'));

      // Get the download URL
      String downloadURL = await storageReference.getDownloadURL();
      print('Download URL: $downloadURL');
      setState(() {
        print("object");
        image = null; // Resetting image file to null
      });
      updateBanner(downloadURL);

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }
}
