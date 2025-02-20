import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextField extends StatefulWidget {
  const BuildTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.keyboardType,
    this.icon,
    this.controller,
    this.width,
    this.axis = 'column',
    this.read = false,
    this.MaxLenght,
    required this.TextSize,
  });

  final String label;
  final String hint;
  final TextInputType keyboardType;
  final double TextSize;
  final double? width;
  final TextEditingController? controller;
  final IconData? icon;
  final int? MaxLenght;
  final String axis;
  final bool read;

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return widget.axis == 'column'
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: TextStyle(fontSize: widget.TextSize)),
              SizedBox(
                height: 50,
                width: widget.width,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.MaxLenght),
                  ],
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  readOnly: widget.read,
                  decoration: InputDecoration(
                    prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
                    hintText: widget.hint,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    fillColor: const Color.fromRGBO(245, 249, 250, 1.0),
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(widget.label, style: TextStyle(fontSize: widget.TextSize)),
              SizedBox(
                height: 50,
                width: widget.width,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.MaxLenght),
                  ],
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  readOnly: widget.read,
                  decoration: InputDecoration(
                    prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
                    hintText: widget.hint,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    fillColor: const Color.fromRGBO(245, 249, 250, 1.0),
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
