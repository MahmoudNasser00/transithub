import 'package:flutter/material.dart';

import 'models.dart'; // استيراد النماذج

class customTextFormField extends StatelessWidget {
  customTextFormField(
      {this.controller,
      this.validator,
      this.keyboardType,
      this.onChanged,
      this.icon,
      this.textSize,
      this.obscureText = false,
      required this.text,
      this.borderSide = BorderSide.none,
      this.color = Colors.white,
      this.textColor = Colors.grey});

  String text;
  Color color, textColor;
  void Function(String)? onChanged;
  String? Function(String?)? validator;
  TextEditingController? controller;
  BorderSide? borderSide;
  TextInputType? keyboardType;
  bool obscureText;
  double? textSize;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50, // استبدل قيمة `height` بقيمة ثابتة
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                obscureText: obscureText,
                keyboardType: keyboardType,
                controller: controller,
                validator: validator,
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: color,
                  hintText: text,
                  hintStyle: TextStyle(color: textColor, fontSize: textSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: borderSide!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble2 extends StatelessWidget {
  ChatBubble2({super.key, required this.message});

  ReceiveMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 32),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 86, 86),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              )),
          child: Text(
            message.messageContent!,
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}

class ChatBubble1 extends StatelessWidget {
  ChatBubble1({super.key, required this.message});

  ReceiveMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding:
              const EdgeInsets.only(left: 32, bottom: 16, top: 16, right: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomRight: Radius.circular(32),
              )),
          child: Text(
            message.messageContent!,
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
