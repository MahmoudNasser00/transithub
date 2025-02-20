import 'package:flutter/material.dart';

class BuildOption extends StatefulWidget {
  const BuildOption({
    Key? key,
    required this.icon,
    required this.index,
    required this.width,
    required this.onPressed,
    required this.isSelected,
    required this.title,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final int index;
  final double width;
  final Function onPressed;
  final bool isSelected;

  @override
  _BuildOptionState createState() => _BuildOptionState();
}

class _BuildOptionState extends State<BuildOption> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          widget.onPressed(widget.index);
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          widget.isSelected
              ? Color.fromRGBO(130, 163, 233, 1)
              : Color.fromRGBO(245, 249, 250, 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon,
          SizedBox(width: widget.width * 0.019),
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: widget.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
