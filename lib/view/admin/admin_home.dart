import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'widget/form_widget.dart';
import 'widget/notification_dialog.dart';

class AdminHomePageView extends StatefulWidget {
  const AdminHomePageView({super.key});

  @override
  State<AdminHomePageView> createState() => _AdminHomePageViewState();
}

class _AdminHomePageViewState extends State<AdminHomePageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  int inde = -1;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
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
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Bold",
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
                    margin: EdgeInsets.only(right: 15),
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
                              text: 'Tab 2',
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
      body: Column(
        children: [
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FormDialogView(
                                      text: "SHELL",
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff4ACA36)),
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "  SHELL CALL  ",
                                  style: TextStyle(color: Color(0xff4ACA36)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FormDialogView(
                                      text: "BUY",
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff4ACA36)),
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "  BUY CALL  ",
                                  style: TextStyle(color: Color(0xff4ACA36)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: BLUE500_COLOR),
                                    borderRadius: BorderRadius.circular(5),
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
                                            left: 8.0, right: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width: w * 0.75,
                                                child: const Text(
                                                  'Sample text from admin',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                            InkWell(
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          width: 1,
                                                          color: Color(
                                                              0xFF4ACA36)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                    ),
                                                    shadows: const [
                                                      BoxShadow(
                                                        color:
                                                        Color(0x234ACA36),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 4),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                  child: const Text(
                                                    'BUY',
                                                    style: TextStyle(
                                                      color: Color(0xFF4ACA36),
                                                      fontSize: 15,
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  )),
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
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                        '100 ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: Image.asset(
                                                        "assets/images/tick.png",
                                                        height: 11,
                                                        width: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Target-1',
                                                style: TextStyle(
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                        '100 ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: Image.asset(
                                                        "assets/images/tick.png",
                                                        height: 11,
                                                        width: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Target-1',
                                                style: TextStyle(
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                        '100 ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: Image.asset(
                                                        "assets/images/tick.png",
                                                        height: 11,
                                                        width: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Target-1',
                                                style: TextStyle(
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
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
                                                      BorderRadius.circular(
                                                          6),
                                                      border: Border.all(
                                                          color: Colors.blue)),
                                                  child: TextFormField(
                                                    decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                        EdgeInsets.all(
                                                            10),
                                                        border: InputBorder
                                                            .none,
                                                        hintText:
                                                        "Enter Message"),
                                                  ))),
                                          Image.asset(
                                            "assets/images/send.png",
                                            height: 50,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  inde = index;
                                                });
                                              },
                                              icon: inde == index
                                                  ? const Icon(
                                                  Icons.keyboard_arrow_down)
                                                  : const Icon(
                                                  Icons.keyboard_arrow_up))
                                        ],
                                      ),
                                      Divider(),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: inde == index?2:0,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              const Text(
                                                'Sample text from admin',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 170,
                                              ),
                                              Image.asset(
                                                "assets/images/delete.png",
                                                height: 30,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
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
                                    child: const Text(
                                      '28/01/2024',
                                      style: TextStyle(
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
                        ),
                      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FormDialogView(
                                      text: "SHELL",
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff4ACA36)),
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "  SHELL CALL  ",
                                  style: TextStyle(color: Color(0xff4ACA36)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FormDialogView(
                                      text: "BUY",
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff4ACA36)),
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "  BUY CALL  ",
                                  style: TextStyle(color: Color(0xff4ACA36)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: BLUE500_COLOR),
                                    borderRadius: BorderRadius.circular(5),
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
                                            left: 8.0, right: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width: w * 0.75,
                                                child: const Text(
                                                  'Sample text from admin',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                            InkWell(
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          width: 1,
                                                          color: Color(
                                                              0xFF4ACA36)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                    ),
                                                    shadows: const [
                                                      BoxShadow(
                                                        color:
                                                        Color(0x234ACA36),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 4),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                  child: const Text(
                                                    'BUY',
                                                    style: TextStyle(
                                                      color: Color(0xFF4ACA36),
                                                      fontSize: 15,
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  )),
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
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                        '100 ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: Image.asset(
                                                        "assets/images/tick.png",
                                                        height: 11,
                                                        width: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Target-1',
                                                style: TextStyle(
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                        '100 ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: Image.asset(
                                                        "assets/images/tick.png",
                                                        height: 11,
                                                        width: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Target-1',
                                                style: TextStyle(
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                        '100 ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: Image.asset(
                                                        "assets/images/tick.png",
                                                        height: 11,
                                                        width: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Target-1',
                                                style: TextStyle(
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
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
                                                      BorderRadius.circular(
                                                          6),
                                                      border: Border.all(
                                                          color: Colors.blue)),
                                                  child: TextFormField(
                                                    decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                        EdgeInsets.all(
                                                            10),
                                                        border: InputBorder
                                                            .none,
                                                        hintText:
                                                        "Enter Message"),
                                                  ))),
                                          Image.asset(
                                            "assets/images/send.png",
                                            height: 50,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  inde = index;
                                                });
                                              },
                                              icon: inde == index
                                                  ? const Icon(
                                                  Icons.keyboard_arrow_down)
                                                  : const Icon(
                                                  Icons.keyboard_arrow_up))
                                        ],
                                      ),
                                      Divider(),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: inde == index?2:0,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              const Text(
                                                'Sample text from admin',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 170,
                                              ),
                                              Image.asset(
                                                "assets/images/delete.png",
                                                height: 30,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
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
                                    child: const Text(
                                      '28/01/2024',
                                      style: TextStyle(
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
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}