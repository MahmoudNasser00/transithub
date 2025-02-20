import 'package:flutter/material.dart';

import 'build_time_field.dart';
import 'build_transportation_options.dart';

class BuildDeliveryDetails extends StatefulWidget {
  const BuildDeliveryDetails({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.selectedRadioTypeAdvertisement,
    required this.fromTimeController,
    required this.toTimeController,
    required this.onTransportationSelected,
  }) : super(key: key);

  final double screenWidth;
  final double screenHeight;
  final int selectedRadioTypeAdvertisement;
  final TextEditingController fromTimeController;
  final TextEditingController toTimeController;
  final ValueChanged<String> onTransportationSelected;

  @override
  _BuildDeliveryDetailsState createState() => _BuildDeliveryDetailsState();
}

class _BuildDeliveryDetailsState extends State<BuildDeliveryDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working time',
          style: TextStyle(fontSize: widget.screenWidth * 0.06),
        ),
        SizedBox(height: widget.screenHeight * 0.004),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BuildTimeField(
              title: 'From',
              height: widget.screenHeight,
              width: widget.screenWidth,
              timeController: widget.fromTimeController,
            ),
            BuildTimeField(
              title: 'To',
              height: widget.screenHeight,
              width: widget.screenWidth,
              timeController: widget.toTimeController,
            ),
          ],
        ),
        SizedBox(height: widget.screenHeight * 0.0112),
        BuildTransportationOptions(
          width: widget.screenWidth,
          height: widget.screenHeight,
          tripType: widget.selectedRadioTypeAdvertisement,
          onTransportationSelected: widget.onTransportationSelected,
        ),
      ],
    );
  }
}
