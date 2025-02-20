import 'package:flutter/material.dart';

class BuildTripTypeButton extends StatefulWidget {
  const BuildTripTypeButton({
    Key? key,
    required this.tripType,
    required this.width,
    required this.selectedRadioTypeAdvertisement,
    required this.onChanged,
  }) : super(key: key);

  final String tripType;
  final double width;
  final int selectedRadioTypeAdvertisement;
  final ValueChanged<int> onChanged;

  @override
  _BuildTripTypeButtonState createState() => _BuildTripTypeButtonState();
}

class _BuildTripTypeButtonState extends State<BuildTripTypeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Text(
            widget.tripType,
            style: TextStyle(fontSize: widget.width * 0.0485),
          ),
          Radio(
            value: widget.tripType == 'Trip' ? 1 : 2,
            groupValue: widget.selectedRadioTypeAdvertisement,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value!);
              });
            },
          ),
        ],
      ),
    );
  }
}
