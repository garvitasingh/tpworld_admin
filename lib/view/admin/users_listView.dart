import 'package:flutter/material.dart';

import 'admin_banners.dart';
import 'widget/notification_dialog.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

int inde = -1;

final List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
  'Item5',
  'Item6',
  'Item7',
  'Item8',
];
String? selectedValue;

class _UsersListViewState extends State<UsersListView> {
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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Users List (2)",
                style: TextStyle(
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
        ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminBannersView()));
              },
              child: ListTile(
                leading: Image.asset(
                  "assets/images/avatar.png",
                  height: 40,
                  fit: BoxFit.cover,
                ),
                title: const Text(
                  "John Bold",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                subtitle: const Text(
                  "+91 9663000773",
                  style: TextStyle(
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
        )
      ]),
    );
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
