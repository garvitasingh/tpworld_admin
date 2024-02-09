// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpworld_admin/main.dart';
import 'package:tpworld_admin/utils/popup.dart';
import 'package:tpworld_admin/view/admin/widget/amount_dialog.dart';
import 'package:tpworld_admin/view/admin/widget/edit_call_dialog.dart';
import 'package:tpworld_admin/view/admin/widget/notification_dialog.dart';

import '../../controller/firestore_controller.dart';
import '../../utils/colors.dart';
import 'widget/form_widget.dart';
import 'package:http/http.dart' as http;

class AdminHomePageView extends StatefulWidget {
  const AdminHomePageView({super.key});

  @override
  State<AdminHomePageView> createState() => _AdminHomePageViewState();
}

class _AdminHomePageViewState extends State<AdminHomePageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController notecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController qtycontroller = TextEditingController();
  TextEditingController target1controller = TextEditingController();
  TextEditingController target2controller = TextEditingController();
  TextEditingController stoplosscontroller = TextEditingController();
  TextEditingController typecallcontroller = TextEditingController();

  List<TextEditingController>? notificationcontroller;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>>? profiles;

  final FirestoreService _firestoreService = FirestoreService();

  List usersToken = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    updateAdminToken();
    super.initState();
  }

  updateAdminToken() async {
    CollectionReference collection = firestore.collection('Admin');
    DocumentSnapshot documentSnapshot = await collection.doc("profile").get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> existingData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<String> existingtokens =
          List<String>.from(existingData['tokens'] ?? []);
      if (!existingtokens.contains(DEVICETOKEN)) {
        existingtokens.add(DEVICETOKEN!);
        await collection.doc("profile").update({
          'tokens': existingtokens,
        });
      }
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop(BuildContext context) async {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      // First time back pressed or exceeds 2 seconds, show a message.
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Do not exit the app.
    } else {
      return true; // Exit the app.
    }
  }

  int inde = -1;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startOfCurrentDay =
        DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfCurrentDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59);

    DateTime previousDay = now.subtract(const Duration(days: 1));
    DateTime startOfPreviousDay =
        DateTime(previousDay.year, previousDay.month, previousDay.day, 0, 0, 0);
    DateTime endOfPreviousDay = DateTime(
        previousDay.year, previousDay.month, previousDay.day, 23, 59, 59);

    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async => onWillPop(context),
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize:
                    const Size.fromHeight(80.0), // here the desired height
                child: AppBar(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  clipBehavior: Clip.none,
                  automaticallyImplyLeading: false,
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
                      onTap: () {
                        showDialog(
                            barrierColor: Colors.transparent,
                            barrierLabel: "fff",
                            context: context,
                            builder: (BuildContext context) {
                              return NotificationDialog();
                            });
                      },
                      child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          )),
                    )
                  ],
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size(400, 50),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12))),
                      width: w,
                      height: 20,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          StreamBuilder<List<Map<String, dynamic>>>(
                              stream: _firestoreService.getProfilesStream(),
                              builder: (context, snapshot) {
                                profiles = snapshot.data!;
                                return const CircularProgressIndicator
                                    .adaptive();
                              }),
                          Positioned(
                            top: 0,
                            child: Container(
                              height: 55,
                              width: w - 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff00367F),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                              ),
                              child: TabBar(
                                labelStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                                onTap: (value) {},
                                indicatorSize: TabBarIndicatorSize.tab,
                                controller: _tabController,
                                // give the indicator a decoration (color and border radius)
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5.0,
                                  ),
                                  color: const Color(0xff00367F),
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black,
                                tabs: const [
                                  // first tab [you can add an icon using the icon property]
                                  Tab(
                                    text: 'Tab 1',
                                  ),

                                  // second tab [you can add an icon using the icon property]
                                  Tab(
                                    text: 'HISTORY',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            body: Column(children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     showDialog(
                              //         barrierColor: Colors.transparent,
                              //         context: context,
                              //         builder: (BuildContext context) {
                              //           return FormDialogView(
                              //             text: "SHELL",
                              //           );
                              //         });
                              //   },
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //             color: const Color(0xff4ACA36)),
                              //         borderRadius: BorderRadius.circular(6)),
                              //     child: const Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         "  SHELL CALL  ",
                              //         style: TextStyle(color: Color(0xff4ACA36)),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  notecontroller.clear();
                                  pricecontroller.clear();
                                  qtycontroller.clear();
                                  target1controller.clear();
                                  target2controller.clear();
                                  stoplosscontroller.clear();
                                  typecallcontroller.clear();
                                  showDialog(
                                      // barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddCallDialog(
                                          totlusers: profiles!,
                                          notecontroller: notecontroller,
                                          pricecontroller: pricecontroller,
                                          qtycontroller: qtycontroller,
                                          target1controller: target1controller,
                                          target2controller: target2controller,
                                          stoplosscontroller:
                                              stoplosscontroller,
                                          typecallcontroller:
                                              typecallcontroller,
                                        );
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0xff4ACA36)),
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
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "   Add Call   ",
                                      style: TextStyle(
                                          color: Color(0xff4ACA36),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Calls')
                                  .where('timestamp',
                                      isGreaterThanOrEqualTo: startOfCurrentDay)
                                  .where('timestamp',
                                      isLessThanOrEqualTo: endOfCurrentDay)
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                if (documents.isEmpty) {
                                  return const Text(
                                      "Today Calls not available!");
                                }
                                int notificationData = documents.length;
                                List<TextEditingController>
                                    notificationcontroller = List.generate(
                                  notificationData,
                                  (index) => TextEditingController(),
                                );
                                return Expanded(
                                    child: ListView.builder(
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    String documentId = documents[index].id;
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: BLUE500_COLOR),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x5B5496EE),
                                                blurRadius: 4,
                                                offset: Offset(0, 4),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        notecontroller.text =
                                                            documents[index]
                                                                    ['Note']
                                                                .toString();
                                                        pricecontroller.text =
                                                            documents[index]
                                                                    ['price']
                                                                .toString();
                                                        qtycontroller.text =
                                                            documents[index]
                                                                    ['quantity']
                                                                .toString();
                                                        target1controller.text =
                                                            documents[index]
                                                                    ['target1']
                                                                .toString();
                                                        target2controller.text =
                                                            documents[index]
                                                                    ['target2']
                                                                .toString();
                                                        stoplosscontroller
                                                            .text = documents[
                                                                    index]
                                                                ['stop_loss']
                                                            .toString();
                                                        typecallcontroller
                                                                .text =
                                                            documents[index]
                                                                    ['calltype']
                                                                .toString();

                                                        showDialog(
                                                            // barrierColor: Colors.transparent,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return EditCallDialog(
                                                                totlusers:
                                                                    profiles!,
                                                                id: documentId
                                                                    .toString(),
                                                                notecontroller:
                                                                    notecontroller,
                                                                pricecontroller:
                                                                    pricecontroller,
                                                                qtycontroller:
                                                                    qtycontroller,
                                                                target1controller:
                                                                    target1controller,
                                                                target2controller:
                                                                    target2controller,
                                                                stoplosscontroller:
                                                                    stoplosscontroller,
                                                                typecallcontroller:
                                                                    typecallcontroller,
                                                              );
                                                            });
                                                      },
                                                      child: SizedBox(
                                                          width: w * 0.6,
                                                          child: Text(
                                                            "${documents[index]["Note"]} @${documents[index]["price"]}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/eye.png",
                                                          // height: 11,
                                                          width: 15,
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          documents[index]
                                                                  ['userids']
                                                              .length
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 4),
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                color: documents[index]['calltype']
                                                                            .toString() ==
                                                                        "BUY"
                                                                    ? const Color(
                                                                        0xFF4ACA36)
                                                                    : const Color(
                                                                        0xffEC1616),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            shadows:  [
                                                              BoxShadow(
                                                                color: documents[index]['calltype']
                                                                            .toString() ==
                                                                        "BUY"
                                                                    ? const Color(
                                                                        0xFF4ACA36)
                                                                    : const Color(
                                                                        0xffEC1616),
                                                                blurRadius: 2,
                                                                offset: const Offset(
                                                                    0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                          child: Text(
                                                            documents[index]
                                                                    ['calltype']
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: documents[index]
                                                                              [
                                                                              'calltype']
                                                                          .toString() ==
                                                                      "BUY"
                                                                  ? const Color(
                                                                      0xFF4ACA36)
                                                                  : const Color(
                                                                      0xffEC1616),
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Rubik',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 0,
                                                            ),
                                                          )),
                                                    ),
                                                    // ignore: prefer_const_constructors
                                                    InkWell(
                                                      onTap: () {
                                                        AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType
                                                              .question,
                                                          animType: AnimType
                                                              .rightSlide,
                                                          title: 'Action',
                                                          desc:
                                                              'Are you sure want to delete this call?',
                                                          btnCancelOnPress:
                                                              () {},
                                                          btnOkOnPress: () {
                                                            _deletcall(
                                                                profiles!,
                                                                documents[index]
                                                                    ['userids'],
                                                                documentId,
                                                                documents[index]
                                                                    ['Note'],
                                                                documents[index]
                                                                    ['price']);
                                                          },
                                                        ).show();
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                color: BLUE300_COLOR,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      documents[index][
                                                                  'target1update'] ==
                                                              true
                                                          ? showSuccessSnackBar(
                                                              context,
                                                              "Already Completed!.")
                                                          : documents[index][
                                                                      'stoplossupdate'] ==
                                                                  true
                                                              ? showErrorSnackBar(
                                                                  context,
                                                                  "Not  Allowed!")
                                                              : showDialog(
                                                                  // barrierColor: Colors.transparent,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AmountDialogView(
                                                                      heading: documents[
                                                                              index]
                                                                          [
                                                                          'Note'],
                                                                      amount: documents[index]
                                                                              [
                                                                              'target1']
                                                                          .toString(),
                                                                      text:
                                                                          "UPDATE",
                                                                      targetvalue:
                                                                          'TARGET-1',
                                                                      documentId:
                                                                          documentId,
                                                                      totlusers:
                                                                          profiles!,
                                                                      users: documents[
                                                                              index]
                                                                          [
                                                                          'userids'],
                                                                    );
                                                                  });
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          child: Row(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  documents[index]
                                                                          [
                                                                          'target1']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                              documents[index][
                                                                              'target1update']
                                                                          .toString() ==
                                                                      "true"
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                                  : Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick_light.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Target-1',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFA8A8A8),
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      documents[index][
                                                                  'target2update'] ==
                                                              true
                                                          ? showSuccessSnackBar(
                                                              context,
                                                              "Already Completed!")
                                                          : documents[index][
                                                                      'target1update'] ==
                                                                  true
                                                              ? documents[index]
                                                                          [
                                                                          'stoplossupdate'] ==
                                                                      true
                                                                  ? showErrorSnackBar(
                                                                      context,
                                                                      "Not  Allowed!")
                                                                  : showDialog(
                                                                      // barrierColor: Colors.transparent,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AmountDialogView(
                                                                          heading:
                                                                              documents[index]['Note'],
                                                                          amount:
                                                                              documents[index]['target2'].toString(),
                                                                          text:
                                                                              "UPDATE",
                                                                          targetvalue:
                                                                              'TARGET-2',
                                                                          documentId:
                                                                              documentId,
                                                                          totlusers:
                                                                              profiles!,
                                                                          users:
                                                                              documents[index]['userids'],
                                                                        );
                                                                      })
                                                              : showErrorSnackBar(
                                                                  context,
                                                                  "First compled Target-1!");
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          child: Row(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  documents[index]
                                                                          [
                                                                          'target2']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                              documents[index][
                                                                              'target2update']
                                                                          .toString() ==
                                                                      "true"
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                                  : Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick_light.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Target-2',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFA8A8A8),
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      documents[index][
                                                                  'stoplossupdate'] ==
                                                              true
                                                          ? showSuccessSnackBar(
                                                              context,
                                                              "already Completed!")
                                                          : documents[index][
                                                                      'target1update'] ==
                                                                  false
                                                              ? showDialog(
                                                                  // barrierColor: Colors.transparent,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AmountDialogView(
                                                                      heading: documents[
                                                                              index]
                                                                          [
                                                                          'Note'],
                                                                      amount: documents[index]
                                                                              [
                                                                              'stop_loss']
                                                                          .toString(),
                                                                      text:
                                                                          "UPDATE",
                                                                      targetvalue:
                                                                          'STOP LOSS',
                                                                      documentId:
                                                                          documentId,
                                                                      totlusers:
                                                                          profiles!,
                                                                      users: documents[
                                                                              index]
                                                                          [
                                                                          'userids'],
                                                                    );
                                                                  })
                                                              : showErrorSnackBar(
                                                                  context,
                                                                  "Not Allowed!");
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          child: Row(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  documents[index]
                                                                          [
                                                                          'stop_loss']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                              documents[index][
                                                                              'stoplossupdate']
                                                                          .toString() ==
                                                                      "true"
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    )
                                                                  : Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick_light.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Stop Loss',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFA8A8A8),
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  documents[index][
                                                                  'target1update'] ==
                                                              true ||
                                                          documents[index][
                                                                  'stoplossupdate'] ==
                                                              true
                                                      ? Column(
                                                          children: [
                                                            Text(
                                                              documents[index][
                                                                      'profilt']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: documents[index]
                                                                            [
                                                                            'stoplossupdate'] ==
                                                                        true
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  documents[index]
                                                                              [
                                                                              'target1update'] ==
                                                                          true
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/images/profit.png",
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          "assets/images/loss.png",
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                  documents[index]
                                                                              [
                                                                              'target1update'] ==
                                                                          true
                                                                      ? const Text(
                                                                          ' Profit',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFA8A8A8),
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        )
                                                                      : const Text(
                                                                          ' loss',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFA8A8A8),
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              const Divider(
                                                color: BLUE300_COLOR,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blue)),
                                                          child: TextFormField(
                                                            controller:
                                                                notificationcontroller[
                                                                    index],
                                                            decoration: const InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "Enter Message"),
                                                          ))),
                                                  InkWell(
                                                    onTap: () {
                                                      _sendnotificationtousers(
                                                          profiles!,
                                                          documents[index]
                                                              ['userids'],
                                                          documentId,
                                                          documents[index]
                                                              ['Note'],
                                                          notificationcontroller[
                                                                  index]
                                                              .text,
                                                          documents[index]
                                                              ['price']);
                                                    },
                                                    child: Image.asset(
                                                      "assets/images/send.png",
                                                      height: 50,
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        hideunhideNotification(
                                                            documentId);
                                                      },
                                                      icon: documents[index][
                                                                  'notificationhide'] ==
                                                              true
                                                          ? const Icon(Icons
                                                              .keyboard_arrow_up)
                                                          : const Icon(Icons
                                                              .keyboard_arrow_down))
                                                ],
                                              ),
                                              // documents[index][
                                              //             'notificationhide'] ==
                                              //         true
                                              //     ? const SizedBox()
                                              //     : const Divider(),
                                              documents[index][
                                                          'notificationhide'] ==
                                                      false
                                                  ? const SizedBox()
                                                  : ListView.separated(
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const Divider(
                                                        color: Colors.blue,
                                                      ),
                                                      shrinkWrap: true,
                                                      reverse: true,
                                                      itemCount: documents[
                                                                  index]
                                                              ['notifications']
                                                          .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        var data = documents[
                                                                index]
                                                            ['notifications'];
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Image.asset(
                                                              "assets/images/bell.png",
                                                              width: 18,
                                                              height: 18,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              width: 250,
                                                              child: Text(
                                                                data[i]['notification']
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                deleteNotificationWithIndex(
                                                                    documentId,
                                                                    i);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/delete.png",
                                                                height: 30,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            color: Colors.white,
                                            child: Text(
                                              documents[index]['datetime']
                                                  .toString(),
                                              style: const TextStyle(
                                                color: BLUE300_COLOR,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ));
                              }),
                        ],
                      ),
                    ),

                    // second tab bar view widget
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Calls')
                                  .where('timestamp',
                                      isGreaterThanOrEqualTo:
                                          startOfPreviousDay,
                                      isLessThanOrEqualTo: endOfPreviousDay)
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                if (documents.isEmpty) {
                                  return const Text("History not available!");
                                }
                                int notificationData = documents.length;
                                List<TextEditingController>
                                    notificationcontroller = List.generate(
                                  notificationData,
                                  (index) => TextEditingController(),
                                );
                                return Expanded(
                                    child: ListView.builder(
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    String documentId = documents[index].id;
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: BLUE500_COLOR),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x5B5496EE),
                                                blurRadius: 4,
                                                offset: Offset(0, 4),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        notecontroller.text =
                                                            documents[index]
                                                                    ['Note']
                                                                .toString();
                                                        pricecontroller.text =
                                                            documents[index]
                                                                    ['price']
                                                                .toString();
                                                        qtycontroller.text =
                                                            documents[index]
                                                                    ['quantity']
                                                                .toString();
                                                        target1controller.text =
                                                            documents[index]
                                                                    ['target1']
                                                                .toString();
                                                        target2controller.text =
                                                            documents[index]
                                                                    ['target2']
                                                                .toString();
                                                        stoplosscontroller
                                                            .text = documents[
                                                                    index]
                                                                ['stop_loss']
                                                            .toString();
                                                        typecallcontroller
                                                                .text =
                                                            documents[index]
                                                                    ['calltype']
                                                                .toString();

                                                        showDialog(
                                                            // barrierColor: Colors.transparent,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return EditCallDialog(
                                                                totlusers:
                                                                    profiles!,
                                                                id: documentId
                                                                    .toString(),
                                                                notecontroller:
                                                                    notecontroller,
                                                                pricecontroller:
                                                                    pricecontroller,
                                                                qtycontroller:
                                                                    qtycontroller,
                                                                target1controller:
                                                                    target1controller,
                                                                target2controller:
                                                                    target2controller,
                                                                stoplosscontroller:
                                                                    stoplosscontroller,
                                                                typecallcontroller:
                                                                    typecallcontroller,
                                                              );
                                                            });
                                                      },
                                                      child: SizedBox(
                                                          width: w * 0.6,
                                                          child: Text(
                                                            "${documents[index]["Note"]} @${documents[index]["price"]}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/eye.png",
                                                          // height: 11,
                                                          width: 15,
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          documents[index]
                                                                  ['userids']
                                                              .length
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 4),
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                color: documents[index]['calltype']
                                                                            .toString() ==
                                                                        "BUY"
                                                                    ? const Color(
                                                                        0xFF4ACA36)
                                                                    : const Color(
                                                                        0xffEC1616),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            shadows:  [
                                                              BoxShadow(
                                                                color: documents[index]['calltype']
                                                                            .toString() ==
                                                                        "BUY"
                                                                    ? const Color(
                                                                        0xFF4ACA36)
                                                                    : const Color(
                                                                        0xffEC1616),
                                                                blurRadius: 2,
                                                                offset: const Offset(
                                                                    0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                          child: Text(
                                                            documents[index]
                                                                    ['calltype']
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: documents[index]
                                                                              [
                                                                              'calltype']
                                                                          .toString() ==
                                                                      "BUY"
                                                                  ? const Color(
                                                                      0xFF4ACA36)
                                                                  : const Color(
                                                                      0xffEC1616),
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Rubik',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 0,
                                                            ),
                                                          )),
                                                    ),
                                                    // ignore: prefer_const_constructors
                                                    InkWell(
                                                      onTap: () {
                                                        AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType
                                                              .question,
                                                          animType: AnimType
                                                              .rightSlide,
                                                          title: 'Action',
                                                          desc:
                                                              'Are you sure want to delete this call?',
                                                          btnCancelOnPress:
                                                              () {},
                                                          btnOkOnPress: () {
                                                            _deletcall(
                                                                profiles!,
                                                                documents[index]
                                                                    ['userids'],
                                                                documentId,
                                                                documents[index]
                                                                    ['Note'],
                                                                documents[index]
                                                                    ['price']);
                                                          },
                                                        ).show();
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                color: BLUE300_COLOR,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      documents[index][
                                                                  'target1update'] ==
                                                              true
                                                          ? showSuccessSnackBar(
                                                              context,
                                                              "Already Completed!.")
                                                          : documents[index][
                                                                      'stoplossupdate'] ==
                                                                  true
                                                              ? showErrorSnackBar(
                                                                  context,
                                                                  "Not  Allowed!")
                                                              : showDialog(
                                                                  // barrierColor: Colors.transparent,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AmountDialogView(
                                                                      heading: documents[
                                                                              index]
                                                                          [
                                                                          'Note'],
                                                                      amount: documents[index]
                                                                              [
                                                                              'target1']
                                                                          .toString(),
                                                                      text:
                                                                          "UPDATE",
                                                                      targetvalue:
                                                                          'TARGET-1',
                                                                      documentId:
                                                                          documentId,
                                                                      totlusers:
                                                                          profiles!,
                                                                      users: documents[
                                                                              index]
                                                                          [
                                                                          'userids'],
                                                                    );
                                                                  });
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          child: Row(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  documents[index]
                                                                          [
                                                                          'target1']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                              documents[index][
                                                                              'target1update']
                                                                          .toString() ==
                                                                      "true"
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                                  : Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick_light.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Target-1',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFA8A8A8),
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      documents[index][
                                                                  'target2update'] ==
                                                              true
                                                          ? showSuccessSnackBar(
                                                              context,
                                                              "Already Completed!")
                                                          : documents[index][
                                                                      'target1update'] ==
                                                                  true
                                                              ? documents[index]
                                                                          [
                                                                          'stoplossupdate'] ==
                                                                      true
                                                                  ? showErrorSnackBar(
                                                                      context,
                                                                      "Not  Allowed!")
                                                                  : showDialog(
                                                                      // barrierColor: Colors.transparent,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AmountDialogView(
                                                                          heading:
                                                                              documents[index]['Note'],
                                                                          amount:
                                                                              documents[index]['target2'].toString(),
                                                                          text:
                                                                              "UPDATE",
                                                                          targetvalue:
                                                                              'TARGET-2',
                                                                          documentId:
                                                                              documentId,
                                                                          totlusers:
                                                                              profiles!,
                                                                          users:
                                                                              documents[index]['userids'],
                                                                        );
                                                                      })
                                                              : showErrorSnackBar(
                                                                  context,
                                                                  "First compled Target-1!");
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          child: Row(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  documents[index]
                                                                          [
                                                                          'target2']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                              documents[index][
                                                                              'target2update']
                                                                          .toString() ==
                                                                      "true"
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                                  : Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick_light.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Target-2',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFA8A8A8),
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      documents[index][
                                                                  'stoplossupdate'] ==
                                                              true
                                                          ? showSuccessSnackBar(
                                                              context,
                                                              "already Completed!")
                                                          : documents[index][
                                                                      'target1update'] ==
                                                                  false
                                                              ? showDialog(
                                                                  // barrierColor: Colors.transparent,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AmountDialogView(
                                                                      heading: documents[
                                                                              index]
                                                                          [
                                                                          'Note'],
                                                                      amount: documents[index]
                                                                              [
                                                                              'stop_loss']
                                                                          .toString(),
                                                                      text:
                                                                          "UPDATE",
                                                                      targetvalue:
                                                                          'STOP LOSS',
                                                                      documentId:
                                                                          documentId,
                                                                      totlusers:
                                                                          profiles!,
                                                                      users: documents[
                                                                              index]
                                                                          [
                                                                          'userids'],
                                                                    );
                                                                  })
                                                              : showErrorSnackBar(
                                                                  context,
                                                                  "Not Allowed!");
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          child: Row(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  documents[index]
                                                                          [
                                                                          'stop_loss']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                              documents[index][
                                                                              'stoplossupdate']
                                                                          .toString() ==
                                                                      "true"
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    )
                                                                  : Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/tick_light.png",
                                                                        height:
                                                                            11,
                                                                        width:
                                                                            11,
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Stop Loss',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFA8A8A8),
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  documents[index][
                                                                  'target1update'] ==
                                                              true ||
                                                          documents[index][
                                                                  'stoplossupdate'] ==
                                                              true
                                                      ? Column(
                                                          children: [
                                                            Text(
                                                              documents[index][
                                                                      'profilt']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: documents[index]
                                                                            [
                                                                            'stoplossupdate'] ==
                                                                        true
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  documents[index]
                                                                              [
                                                                              'target1update'] ==
                                                                          true
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/images/profit.png",
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          "assets/images/loss.png",
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                  documents[index]
                                                                              [
                                                                              'target1update'] ==
                                                                          true
                                                                      ? const Text(
                                                                          ' Profit',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFA8A8A8),
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        )
                                                                      : const Text(
                                                                          ' loss',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFA8A8A8),
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              const Divider(
                                                color: BLUE300_COLOR,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blue)),
                                                          child: TextFormField(
                                                            controller:
                                                                notificationcontroller[
                                                                    index],
                                                            decoration: const InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "Enter Message"),
                                                          ))),
                                                  InkWell(
                                                    onTap: () {
                                                      _sendnotificationtousers(
                                                          profiles!,
                                                          documents[index]
                                                              ['userids'],
                                                          documentId,
                                                          documents[index]
                                                              ['Note'],
                                                          notificationcontroller[
                                                                  index]
                                                              .text,
                                                          documents[index]
                                                              ['price']);
                                                    },
                                                    child: Image.asset(
                                                      "assets/images/send.png",
                                                      height: 50,
                                                    ),
                                                  ),
                                                 IconButton(
                                                      onPressed: () {
                                                        hideunhideNotification(
                                                            documentId);
                                                      },
                                                      icon: documents[index][
                                                                  'notificationhide'] ==
                                                              true
                                                          ? const Icon(Icons
                                                              .keyboard_arrow_up)
                                                          : const Icon(Icons
                                                              .keyboard_arrow_down))
                                                ],
                                              ),
                                              // documents[index][
                                              //             'notificationhide'] ==
                                              //         true
                                              //     ? const SizedBox()
                                              //     : const Divider(),
                                              documents[index][
                                                          'notificationhide'] ==
                                                      false
                                                  ? const SizedBox()
                                                  : ListView.separated(
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const Divider(
                                                        color: Colors.blue,
                                                      ),
                                                      shrinkWrap: true,
                                                      reverse: true,
                                                      itemCount: documents[
                                                                  index]
                                                              ['notifications']
                                                          .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        var data = documents[
                                                                index]
                                                            ['notifications'];
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Image.asset(
                                                              "assets/images/bell.png",
                                                              width: 18,
                                                              height: 18,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              width: 250,
                                                              child: Text(
                                                                data[i]['notification']
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                deleteNotificationWithIndex(
                                                                    documentId,
                                                                    i);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/delete.png",
                                                                height: 30,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            color: Colors.white,
                                            child: Text(
                                              documents[index]['datetime']
                                                  .toString(),
                                              style: const TextStyle(
                                                color: BLUE300_COLOR,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ));
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }

  Future<void> hideunhideNotification(id) async {
    CollectionReference collection = firestore.collection('Calls');
    DocumentSnapshot documentSnapshot = await collection.doc(id).get();

    if (documentSnapshot.exists) {
      dynamic data = documentSnapshot.data();
      if (data['notificationhide'].toString() == "true") {
        await collection.doc(id).update({
          'notificationhide': false,
        });
      } else {
        await collection.doc(id).update({
          'notificationhide': true,
        });
      }
    }
  }

  Future<void> deleteNotificationWithIndex(String id, int index) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Calls');
    DocumentSnapshot documentSnapshot = await collection.doc(id).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> existingData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<Map<String, dynamic>> existingNotifications =
          List<Map<String, dynamic>>.from(existingData['notifications'] ?? []);

      // Check if the index is valid
      if (index >= 0 && index < existingNotifications.length) {
        // Remove the notification at the specified index
        existingNotifications.removeAt(index);

        // Update the Firestore document with the modified list
        await collection.doc(id).update({
          'notifications': existingNotifications,
        });
      } else {
        print('Invalid index: $index');
      }
    }

    // Show success snackbar if needed
    // showSuccessSnackBar(context, "Notification Deleted!");
  }

  Future<void> addNotificationWithId(
      String id, String notification, userIds, price) async {
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

  _deletcall(
      List totlusers, List users, documentId, documentName, price) async {
    deleteCall(documentId);
    for (var i = 0; i < totlusers.length; i++) {
      pushnotificationapi(
          documentName,
          'some reasons we are deleted this call.',
          totlusers[i]['token'],
          price);
    }
    // for (var id in users) {
    //   var user = totlusers.firstWhere(
    //     (user) => user['id'] == id,
    //   );
    //   if (user != null) {
    //     pushnotificationapi(documentName, 'deleted', user['token'], price);
    //   } else {
    //     print('ID $id is not present in the userList.');
    //   }
    // }
  }

  void deleteCall(String documentId) async {
    // Get the reference to the document
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Calls').doc(documentId);

    // Delete the document
    await documentReference.delete();
    showSuccessSnackBar(context, "Delete!");
  }

  Future<void> _sendnotificationtousers(
    List totlusers,
    List users,
    documentId,
    documentName,
    notification,
    price,
  ) async {
    addNotificationWithId(documentId, notification, totlusers, price);

    for (var i = 0; i < totlusers.length; i++) {
      pushnotificationapi(
          documentName, notification.toString(), totlusers[i]['token'], price);
      addNotification(totlusers[i]['id'], documentName, notification,
          totlusers[i]['token'], price);
    }
  }

  Future<void> addNotification(
      String userId, String title, String body, String token, price) async {
    try {
      Map<String, dynamic> notification = {
        'title': "${title} @${price}",
        'body': body,
        'time': DateTime.now(),
        'isRead': false,
      };

      await firestore.collection('users').doc(userId).update({
        'notifications': FieldValue.arrayUnion([notification]),
      });
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  pushnotificationapi(title, body, token, price) async {
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
        'title': "${title} @${price}",
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
