import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'build_option.dart';

class BuildTransportationOptions extends StatefulWidget {
  const BuildTransportationOptions({
    Key? key,
    required this.width,
    required this.height,
    required this.tripType,
    required this.onTransportationSelected,
  }) : super(key: key);

  final double width;
  final double height;
  final int tripType;
  final ValueChanged<String> onTransportationSelected;

  @override
  _BuildTransportationOptionsState createState() =>
      _BuildTransportationOptionsState();
}

class _BuildTransportationOptionsState
    extends State<BuildTransportationOptions> {
  List<String> _transportationName = [
    'Car',
    'Bus',
    'Motorcycle',
    'Train',
    'Airplane',
  ];

  List<Icon> _transportationIcon = [
    Icon(CupertinoIcons.car_detailed, color: Colors.black),
    Icon(CupertinoIcons.bus, color: Colors.black),
    Icon(Icons.motorcycle_sharp, color: Colors.black),
    Icon(CupertinoIcons.tram_fill, color: Colors.black),
    Icon(CupertinoIcons.airplane, color: Colors.black),
  ];
  List<bool> _isSelected = List.filled(5, false);

  void _handleOptionSelected(int index) {
    setState(() {
      if (widget.tripType == 1) {
        _isSelected = List.generate(5, (i) => i == index);
        widget.onTransportationSelected(_transportationName[index]);
      } else {
        _isSelected = List.generate(4, (i) => i == index);
        widget.onTransportationSelected(_transportationName[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      runSpacing: widget.height * 0.005,
      children: List.generate(
        widget.tripType == 1 ? 5 : 4,
        (index) => BuildOption(
          title: _transportationName[index],
          icon: _transportationIcon[index],
          index: index,
          width: widget.width,
          onPressed: _handleOptionSelected,
          isSelected: _isSelected[index],
        ),
      ),
    );
  }
}
