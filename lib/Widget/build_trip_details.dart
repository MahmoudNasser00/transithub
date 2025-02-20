import 'package:flutter/material.dart';
import 'package:transithub/Widget/build_date_field.dart';
import 'package:transithub/Widget/build_text_field.dart';
import 'package:transithub/Widget/build_time_field.dart';
import 'package:transithub/Widget/build_transportation_options.dart';

class BuildTripDetails extends StatefulWidget {
  const BuildTripDetails({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.selectedRadioTypeAdvertisement,
    required this.startLocationController,
    required this.endLocationController,
    required this.dateController,
    required this.timeController,
    required this.onTransportationSelected,
  }) : super(key: key);

  final double screenWidth;
  final double screenHeight;
  final int selectedRadioTypeAdvertisement;
  final TextEditingController startLocationController;
  final TextEditingController endLocationController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final ValueChanged<String> onTransportationSelected;

  @override
  _BuildTripDetailsState createState() => _BuildTripDetailsState();
}

class _BuildTripDetailsState extends State<BuildTripDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuildTextField(
          TextSize: widget.screenWidth * .05,
          label: "Start location trip",
          hint: "Enter start point",
          keyboardType: TextInputType.text,
          controller: widget.startLocationController,
          width: widget.screenWidth,
        ),
        SizedBox(height: widget.screenHeight * 0.0112),
        BuildTextField(
          TextSize: widget.screenWidth * .05,
          label: "End location trip",
          hint: "Enter end point",
          keyboardType: TextInputType.text,
          controller: widget.endLocationController,
          width: widget.screenWidth,
        ),
        SizedBox(height: widget.screenHeight * 0.0112),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BuildDateField(
              controller: widget.dateController,
              width: widget.screenWidth,
              height: widget.screenHeight,
              label: "Trip date",
            ),
            BuildTimeField(
              width: widget.screenWidth,
              height: widget.screenHeight,
              title: 'Trip time',
              timeController: widget.timeController,
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
