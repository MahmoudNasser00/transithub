import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transithub/Map/get%20location.dart';
import 'package:transithub/Widget/build_text_field.dart';

import '../Widget/searsh_trip.dart';
import '../widget/build_trip_type_button.dart';
import '../widget/search_delivery.dart';

class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({Key? key}) : super(key: key);

  @override
  State<PostSearchScreen> createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {
  int _selectedRadioTypeAdvertisement = 1;

  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  String? _currentLocation;
  LocationService locationService = LocationService();
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    String location = await locationService.getCurrentLocation();
    setState(() {
      _currentLocation = location;
    });
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedRadioTypeAdvertisement = value ?? 1;
    });
  }

  void _search() {
    setState(() {
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Trip'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.03,
          screenWidth * 0.04,
          screenWidth * 0.03,
          0,
        ),
        child: ListView(
          children: [
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
                  selectedRadioTypeAdvertisement:
                      _selectedRadioTypeAdvertisement,
                  onChanged: _handleRadioValueChange,
                ),
                BuildTripTypeButton(
                  tripType: "Delivery",
                  width: screenWidth,
                  selectedRadioTypeAdvertisement:
                      _selectedRadioTypeAdvertisement,
                  onChanged: _handleRadioValueChange,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildSearchForm(screenHeight),
            SizedBox(height: screenHeight * 0.02),
            _buildSubmitButton(screenHeight),
            SizedBox(height: screenHeight * 0.02),
            if (_showResults) _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm(double screenHeight) {
    if (_selectedRadioTypeAdvertisement == 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BuildTextField(
            label: "Start Location",
            hint: "Enter start point",
            keyboardType: TextInputType.text,
            TextSize: screenHeight * 0.02,
            width: screenHeight * 0.18,
            controller: _startLocationController,
          ),
          BuildTextField(
            label: "End Location",
            hint: "Enter end point",
            keyboardType: TextInputType.text,
            TextSize: screenHeight * 0.02,
            width: screenHeight * 0.18,
            controller: _endLocationController,
          ),
        ],
      );
    } else {
      return DeliveryResultsScreen(currentLocation: _currentLocation ?? "");
    }
  }

  Widget _buildSubmitButton(double screenHeight) {
    return Center(
      child: CupertinoButton(
        padding: EdgeInsets.all(screenHeight * 0.016),
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromRGBO(133, 209, 209, 1),
        child: Text(
          'Search',
          style: TextStyle(
            fontSize: screenHeight * 0.023,
            color: Colors.black,
          ),
        ),
        onPressed: _search,
      ),
    );
  }

  Widget _buildResults() {
    if (_selectedRadioTypeAdvertisement == 1) {
      return TripResultsScreen(
        endLocation: _endLocationController.text,
        startLocation: _startLocationController.text,
      );
    } else {
      return DeliveryResultsScreen(
        currentLocation: _currentLocation ?? "",
      );
    }
  }
}
