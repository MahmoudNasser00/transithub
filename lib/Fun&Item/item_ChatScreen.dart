// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ItemChatScreen extends StatelessWidget {
  const ItemChatScreen({
    super.key,
    required this.chatTitle,
    required this.subTitle,
    required this.timeLastMassage,
    required this.notification,
    required this.route,
    required this.phoneNumber,
  });

  final String chatTitle;
  final String subTitle;
  final DateTime timeLastMassage;
  final bool notification;
  final Widget route;
  final int phoneNumber;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Opacity(
        opacity: 1.0,
        child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => route));
            },
            child: SizedBox(
              width: w,
              height: h * .09,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(
                          'assets/images/face.png',
                        ),
                      ),
                      SizedBox(
                        width: w * .04,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(chatTitle,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            height: h * .005,
                          ),
                          Text(
                            subTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w100,
                            ),
                          )
                        ],
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (notification)
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                              ),
                            ),
                          SizedBox(
                            height: h * .005,
                          ),
                          Text(timeLastMassage.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
            )));
  }
}
