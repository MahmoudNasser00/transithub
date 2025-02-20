import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildDateField extends StatefulWidget {
  const BuildDateField({
    Key? key,
    required this.label,
    required this.width,
    required this.height,
    required this.controller,
  }) : super(key: key);
  final String label;
  final double width;
  final double height;
  final TextEditingController? controller;

  @override
  _BuildDateFieldState createState() => _BuildDateFieldState();
}

class _BuildDateFieldState extends State<BuildDateField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontSize: widget.width * 0.0485)),
        SizedBox(
          height: widget.height * 0.056,
          width: widget.width * 0.4,
          child: TextField(
            textAlign: TextAlign.center,
            maxLines: null,
            expands: true,
            obscureText: false,
            controller: widget.controller,
            readOnly: true,
            onTap: () {
              _selectDate(context);
            },
            decoration: const InputDecoration(
              hintText: 'Select date ',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              fillColor: Color.fromRGBO(245, 249, 250, 1.0),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10000)),
              ),
              prefixIcon: Icon(
                CupertinoIcons.calendar,
                color: Color.fromRGBO(139, 0, 33, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        widget.controller!.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }
}
