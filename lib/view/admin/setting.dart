import 'package:flutter/material.dart';
import 'package:tpworld_admin/view/admin/admin_banners.dart';
import 'package:tpworld_admin/view/admin/widget/notification_dialog.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Settings",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminBannersView()));
              },
              child: const Text("Manage Banners",
                  style: TextStyle(
                      color: Color(0xff00367F),
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Color(0xff5496EE),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text("Update Terms And Conditions",
                style: TextStyle(
                    color: Color(0xff00367F),
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Color(0xff5496EE),
            ),
          ],
        ),
      ),
    );
  }
}
