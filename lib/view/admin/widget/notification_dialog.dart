import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      alignment: Alignment.topRight,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
                  icon: Image.asset(
                    "assets/images/setting.png",
                    height: 24,
                  ),
                  onPressed: () {
                    // Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xffF8F8FA),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Smart card’s balance is about to get to 0. Please, make your payment.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "today",
                            style: TextStyle(color: Colors.black),
                          ),
                          Image.asset(
                            "assets/images/delete.png",
                            height: 30,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Delete All",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
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
        ],
      ),
    );
  }
}
