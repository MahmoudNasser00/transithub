import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildPasswordTextField extends StatefulWidget {
  BuildPasswordTextField({
    super.key,
    required this.TextSize,
    this.controller,
    this.width,
    this.hint = "Enter Password",
    this.label = "Password",
  });

  final double TextSize;
  final double? width;
  final TextEditingController? controller;
  String hint;
  String label;

  @override
  _BuildPasswordTextFieldState createState() => _BuildPasswordTextFieldState();
}

class _BuildPasswordTextFieldState extends State<BuildPasswordTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: TextStyle(fontSize: widget.TextSize)),
      SizedBox(
          height: 50,
          width: widget.width,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(CupertinoIcons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(
                  isPasswordVisible
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                ),
              ),
              hintText: widget.hint,
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              fillColor: const Color.fromRGBO(245, 249, 250, 1),
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ))
    ]);
  }
}
