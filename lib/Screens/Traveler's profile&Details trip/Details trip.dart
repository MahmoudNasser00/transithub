import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:transithub/Account%20manegement/Account_manage_API.dart';
import 'package:transithub/Chat/chat_screen.dart';
import 'package:transithub/Map/distance_calculator.dart';
import 'package:transithub/Map/map_screen.dart';

import '../../Map/location_service.dart';
import '../../Rating(Get&Show)/Ratig show.dart';

class DetailsTrip extends StatefulWidget {
  const DetailsTrip({
    Key? key,
    required this.from,
    required this.to,
    required this.travelerName,
    required this.transportionType,
    required this.numberOfTrip,
    required this.travelerId,
    required this.tripTime,
    required this.tripDate,
    required this.travelerImage,
  }) : super(key: key);
  final NetworkImage travelerImage;
  final String from;
  final String to;
  final String travelerName;
  final String transportionType;
  final String numberOfTrip;
  final String travelerId;
  final String tripTime;
  final String tripDate;

  @override
  _DetailsTripState createState() => _DetailsTripState();
}

class _DetailsTripState extends State<DetailsTrip> {
  LatLng? _startLatLng;
  LatLng? _endLatLng;
  List<LatLng> _routePoints = [];
  double? _distance;
  bool _isLoading = false;
  String? _errorMessage;
  late String _userId;

  @override
  void initState() {
    super.initState();
    setState(() {
      _getUserId();
      _initializeLocations();
      _calculateRoute();
    });
  }

  void _getUserId() async {
    String? userId = await Access().getUserId();
    setState(() {
      _userId = userId!;
    });
  }

  Future<void> _initializeLocations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _startLatLng = await _getLatLngFromQuery(widget.from);
      _endLatLng = await _getLatLngFromQuery(widget.to);

      if (_startLatLng != null && _endLatLng != null) {
        _calculateRoute();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize locations';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _calculateRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_startLatLng != null && _endLatLng != null) {
        final routePoints = await getRoute(_startLatLng!, _endLatLng!);
        setState(() {
          _routePoints = routePoints;
          _distance = calculateDistance(_startLatLng!, _endLatLng!);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to calculate route';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<LatLng?> _getLatLngFromQuery(String query) async {
    try {
      final latLng = await getLatLng(query);
      return latLng;
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get location';
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details trip'),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: screenHeight * 0.022,
          left: screenWidth * 0.035,
          right: screenWidth * 0.035,
        ),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Widget>(
                future: Future.delayed(const Duration(seconds: 2), () {
                  return MapScreen(
                      startLocation: widget.from, endLocation: widget.to);
                }),
                builder:
                    (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox(
                        width: screenWidth,
                        height: screenHeight * .5,
                        child: snapshot.data ?? const Text('No rating yet'));
                  }
                },
              ),
              SizedBox(
                height: screenWidth * .05,
              ),
              Text(
                'From: ${widget.from}',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                'To: ${widget.to}',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(
                      color: Colors.red, fontSize: screenWidth * 0.05),
                ),
              if (_distance != null)
                Text(
                  'Distance: ${_distance!.toStringAsFixed(2)} km',
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
              Text(
                "Traveler's name: ${widget.travelerName}",
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                'Transportation type: ${widget.transportionType}',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                'Number of trip: ${widget.numberOfTrip}',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                "Traveler's rate:",
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              SizedBox(
                height: screenWidth * .05,
              ),
              FutureBuilder<Widget>(
                future: Future.delayed(const Duration(seconds: 2), () {
                  return RatingShow(id: widget.travelerId);
                }),
                builder:
                    (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return snapshot.data ?? const Text('No rating yet');
                  }
                },
              ),
              SizedBox(
                height: screenWidth * .05,
              ),
              Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              WidgetStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(5000),
                          )),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsetsDirectional.all(10),
                          ),
                          backgroundColor: const WidgetStatePropertyAll(
                            Color.fromRGBO(133, 209, 209, 1),
                          )),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              senderId: _userId,
                              reseverId: widget.travelerId,
                              reseverName: widget.travelerName,
                              reseverImage: widget.travelerImage,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Chat with traveler',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ))),
            ],
          ),
        ],
      ),
    );
  }
}
