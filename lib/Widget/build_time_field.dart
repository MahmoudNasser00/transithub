import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildTimeField extends StatefulWidget {
  const BuildTimeField({
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    required this.timeController,
  }) : super(key: key);
  final double width;
  final double height;
  final String title;
  final TextEditingController? timeController;

  @override
  _BuildTimeFieldState createState() => _BuildTimeFieldState();
}

class _BuildTimeFieldState extends State<BuildTimeField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontSize: widget.width * 0.04)),
        SizedBox(
          height: widget.height * 0.056,
          width: widget.width * 0.4,
          child: TextField(
            textAlign: TextAlign.center,
            maxLines: null,
            expands: true,
            obscureText: false,
            controller: widget.title == 'To'
                ? widget.timeController
                : widget.timeController,
            readOnly: true,
            onTap: () {
              if (widget.title == 'To') {
                _selectTimeto(context);
              } else {
                _selectTime(context);
              }
            },
            decoration: const InputDecoration(
              hintText: 'Select time ',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              fillColor: Color.fromRGBO(245, 249, 250, 1.0),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10000)),
              ),
              prefixIcon: Icon(
                CupertinoIcons.clock,
                color: Color.fromRGBO(139, 0, 33, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        widget.timeController?.text = picked.format(context);
      });
    }
  }

  Future<void> _selectTimeto(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        widget.timeController?.text = picked.format(context);
      });
    }
  }
}
