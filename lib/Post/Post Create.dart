import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transithub/Widget/build_delivery_details.dart';
import 'package:transithub/Widget/build_trip_details.dart';
import 'package:transithub/Widget/build_trip_type_button.dart';

import '../Account manegement/Account_manage_API.dart';
import '../Map/get location.dart';

class PostWidgetCreate extends StatefulWidget {
  const PostWidgetCreate({Key? key}) : super(key: key);

  @override
  State<PostWidgetCreate> createState() => _PostWidgetCreateState();
}

class _PostWidgetCreateState extends State<PostWidgetCreate> {
  int _selectedRadioTypeAdvertisement = 1;

  // Add text controllers to store user input
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  String? _currentLocation;
  LocationService locationService = LocationService();
  late String _selectedTransportationType;

  @override
  void initState() {
    super.initState();
    _initializeAdvertisementData();
    _fetchLocation();
    setState(() {});
  }

  Future<void> _fetchLocation() async {
    String location = await locationService.getCurrentLocation();
    setState(() {
      _currentLocation = location;
    });
  }

  String convertDate(String inputDate) {
    DateFormat originalFormat = DateFormat('MM/dd/yyyy');
    DateFormat newFormat = DateFormat('yyyy-MM-dd');

    DateTime dateTime = originalFormat.parse(inputDate);

    String formattedDate = newFormat.format(dateTime);

    return formattedDate;
  }

  String convertTimeTo24HourFormat(String time) {
    final DateFormat inputFormat = DateFormat("hh:mm a");
    final DateFormat outputFormat = DateFormat("HH:mm");

    final DateTime dateTime = inputFormat.parse(time);
    final String formattedTime = outputFormat.format(dateTime);

    return formattedTime;
  }

  void _initializeAdvertisementData() async {
    // Validate input fields
    if (_selectedRadioTypeAdvertisement == 1) {
      if (_startLocationController.text.isEmpty ||
          _endLocationController.text.isEmpty ||
          _dateController.text.isEmpty ||
          _timeController.text.isEmpty ||
          _selectedTransportationType.isEmpty) {
        // Show error message
        _showErrorMessage('Please fill in all required fields.');
        return;
      }
    } else {
      if (_fromTimeController.text.isEmpty ||
          _toTimeController.text.isEmpty ||
          _selectedTransportationType.isEmpty ||
          _currentLocation == null) {
        // Show error message
        _showErrorMessage('Please fill in all required fields.');
        return;
      }
    }

    // Proceed with API call
    if (_selectedRadioTypeAdvertisement == 1) {
      TripManager().addTrip(
        startLocation: _startLocationController.text,
        endLocation: _endLocationController.text,
        dateOfTrip:
            "${convertDate(_dateController.text)}T${convertTimeTo24HourFormat(_timeController.text)}",
        viechelType: _selectedTransportationType,
      );
    } else {
      LocalTripManager().createLocalTrip(
        from: convertTimeTo24HourFormat(_fromTimeController.text),
        to: convertTimeTo24HourFormat(_toTimeController.text),
        VichelType: _selectedTransportationType,
        position: _currentLocation!,
      );
    }

    // Show success message
    _showSuccessMessage('Your advertisement has been successfully shared!');
  }

  void _showSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedRadioTypeAdvertisement = value ?? 1;
    });
  }

  void _handleTransportationSelection(String selectedType) {
    setState(() {
      _selectedTransportationType = selectedType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.03,
        screenWidth * 0.04,
        screenWidth * 0.03,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Create an advertisement for the trip',
              style: TextStyle(fontSize: screenWidth * 0.05),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Type of Advertisement',
            style: TextStyle(fontSize: screenWidth * 0.0485),
          ),
          SizedBox(height: screenHeight * 0.004),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BuildTripTypeButton(
                tripType: "Trip",
                width: screenWidth,
                selectedRadioTypeAdvertisement: _selectedRadioTypeAdvertisement,
                onChanged: _handleRadioValueChange,
              ),
              BuildTripTypeButton(
                tripType: "Delivery",
                width: screenWidth,
                selectedRadioTypeAdvertisement: _selectedRadioTypeAdvertisement,
                onChanged: _handleRadioValueChange,
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _selectedRadioTypeAdvertisement == 1
              ? BuildTripDetails(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  selectedRadioTypeAdvertisement:
                      _selectedRadioTypeAdvertisement,
                  startLocationController: _startLocationController,
                  endLocationController: _endLocationController,
                  dateController: _dateController,
                  timeController: _timeController,
                  onTransportationSelected: _handleTransportationSelection,
                )
              : BuildDeliveryDetails(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  selectedRadioTypeAdvertisement:
                      _selectedRadioTypeAdvertisement,
                  fromTimeController: _fromTimeController,
                  toTimeController: _toTimeController,
                  onTransportationSelected: _handleTransportationSelection,
                ),
          SizedBox(height: screenHeight * 0.1),
          _buildSubmitButton(screenHeight),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(double screenHeight) {
    return Center(
      child: CupertinoButton(
        padding: EdgeInsets.all(screenHeight * 0.016),
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromRGBO(133, 209, 209, 1),
        child: Text(
          'Share my trip',
          style: TextStyle(
            fontSize: screenHeight * 0.023,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          _initializeAdvertisementData();
        },
      ),
    );
  }
}
