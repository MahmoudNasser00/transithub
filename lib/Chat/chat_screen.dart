import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:transithub/QR/scanner%20_q_r.dart';

import '../Payment/pay.dart';
import 'custom_widgets.dart';
import 'models.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.senderId,
    required this.reseverId,
    required this.reseverName,
    required this.reseverImage,
  });

  final String senderId;
  final String reseverId;
  final String reseverName;
  final NetworkImage reseverImage;

  static String id = 'ChatScreen';
  int i = 0;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();
  List<ReceiveMessageModel> messageList = [];

  @override
  void initState() {
    receiveMessage(senderId: widget.senderId, reseverId: widget.reseverId);
    receiveMessage(senderId: widget.reseverId, reseverId: widget.senderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.i == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          widget.i = 1;
        });
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/photo_2024-05-03_20-09-05.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              buildHeader(context),
              buildMessageList(),
              buildInputField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return Expanded(
        child: messageList.isEmpty
            ? Container()
            : ListView.builder(
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  log("messageList[index].sender ${messageList[index].toJson()}");
                  messageList.sort((a, b) {
                    DateTime dateTimeA = DateTime.parse(a.time!);
                    DateTime dateTimeB = DateTime.parse(b.time!);
                    return dateTimeA.compareTo(dateTimeB);
                  });
                  return messageList[index].sender == widget.senderId
                      ? ChatBubble2(message: messageList[index])
                      : Row(
                          children: [
                            ChatBubble1(message: messageList[index]),
                            const Spacer(),
                          ],
                        );
                }));
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(255, 255, 255, 0.4),
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.arrow_back),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.transparent),
                child: Image(
                  image: widget.reseverImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.reseverName,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Done Order') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ScannerQR();
                    }));
                  } else if (value == 'Order Qr Create') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Pay(delevaryId: widget.reseverId);
                    }));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Order Qr Create',
                    child: Text('Order Qr Create'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Done Order',
                    child: Text('Done Order'),
                  ),
                ],
                color: const Color.fromRGBO(255, 255, 255, 0.75),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          0.05), // تعديل شكل الحواف
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInputField() {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(500),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.055,
        child: Row(
          children: [
            Expanded(
              child: customTextFormField(
                controller: message,
                color: Colors.transparent,
                text: '  Enter The Message...',
              ),
            ),
            Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5000),
                color: const Color.fromARGB(255, 14, 144, 146),
              ),
              child: InkWell(
                onTap: () async {
                  log("message: ${message.text}");
                  await sendMessage(
                      message: message.text,
                      senderId: widget.senderId,
                      reseverId: widget.reseverId);
                  message.clear();
                  messageList.clear();
                  await receiveMessage(
                      senderId: widget.senderId, reseverId: widget.reseverId);
                  await receiveMessage(
                      senderId: widget.reseverId, reseverId: widget.senderId);
                  setState(() {});
                },
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage(
      {required String message,
      required String senderId,
      required String reseverId}) async {
    Dio dio = Dio();
    try {
      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
      );
      Map<String, dynamic> data = {
        "messageContent": message,
        "senderId": senderId,
        "reseverId": reseverId,
      };
      Response response = await dio.post(
          "http://transithub.runasp.net/api/Message/CreateMessage",
          data: data,
          options: options);
      if (response.statusCode == 200) {
        log("message sent successfully $message");
      } else {
        log("${response.statusCode} message was not sent successfully");
      }
    } catch (e) {
      log("message was not sent successfully cache : $e");
    }
  }

  Future<void> receiveMessage(
      {required String senderId, required String reseverId}) async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(
        "http://transithub.runasp.net/api/Message?snderId=$senderId&receverId=$reseverId",
      );
      if (response.statusCode == 200) {
        log("message sent successfully ${response.data}");
        List items = response.data;
        items
            .map((e) => messageList.add(ReceiveMessageModel.fromJson(e)))
            .toList();
        setState(() {});
      } else {
        log("${response.statusCode} message was not sent successfully");
      }
    } catch (e) {
      log("message was not sent successfully cache : $e");
    }
  }
}
