import 'package:flutter/material.dart';

import 'widget/notification_dialog.dart';

class AdminBannersView extends StatefulWidget {
  const AdminBannersView({super.key});

  @override
  State<AdminBannersView> createState() => _AdminBannersViewState();
}

class _AdminBannersViewState extends State<AdminBannersView> {
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
          )),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue)),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100,
                  child: const Center(
                      child: Text(
                    "Banner",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                const Divider(),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue)),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  border: InputBorder.none,
                                  hintText: "Enter Message"),
                            ))),
                    Image.asset(
                      "assets/images/send.png",
                      height: 50,
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Banners List",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue)),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10,),
                      Container(
                        height: 100,
                        child: const Center(
                            child: Text(
                          "Banner Image",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
                      Image.asset(
                        "assets/images/delete.png",
                        height: 30,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Text(
                  "Sample Text From Admin Sample Text From Admin Sample\nText From Admin.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
