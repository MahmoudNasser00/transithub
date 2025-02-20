import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:transithub/Chat/chat_screen.dart';

import '../Account manegement/Account_manage_API.dart';

class PositionParts {
  final String part1;
  final String part2;

  PositionParts(this.part1, this.part2);
}

PositionParts splitString(String userPosition) {
  List<String> parts = userPosition.split(',');
  return PositionParts(parts[0], parts[1]);
}

class DeliveryResultsScreen extends StatefulWidget {
  final String currentLocation;

  const DeliveryResultsScreen({required this.currentLocation, Key? key})
      : super(key: key);

  @override
  _DeliveryResultsScreenState createState() => _DeliveryResultsScreenState();
}

class _DeliveryResultsScreenState extends State<DeliveryResultsScreen> {
  final LocalTripManager localTripManager = LocalTripManager();
  Position? currentPosition;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
    _getCurrentLocation();
  }

  void _getUserId() async {
    String? userId = await Access().getUserId();
    setState(() {
      _userId = userId!;
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return currentPosition == null
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder<List<Map<String, dynamic>>>(
            future: localTripManager.getAllLocalTrips(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No local trips available'));
              }

              final localTrips = snapshot.data!;

              return Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: localTrips.length,
                    itemBuilder: (context, index) {
                      final trip = localTrips[index];
                      final from = trip['from'] as String? ?? '';
                      final to = trip['to'] as String? ?? '';
                      final vehicleType = trip['vehicleType'] as String? ?? '';
                      final position = trip['position'] as String? ?? '';
                      final delevaryName = trip['userName'] as String? ?? '';
                      final photoUrl = NetworkImage(
                          trip['imageUrl'] as String? ??
                              'https://via.placeholder.com/150');
                      final delevaryId = trip['userId'] as String? ?? '';

                      PositionParts parts = splitString(position);
                      double part1 = double.parse(parts.part1);
                      double part2 = double.parse(parts.part2);

                      double distance = calculateDistance(
                        currentPosition!.latitude,
                        currentPosition!.longitude,
                        part1,
                        part2,
                      );

                      // Check if the distance is less than the desired distance (e.g., 50km)
                      if (distance <= 200) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                          child: InkWell(
                            onLongPress: () {
                              print('See more');
                            },
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    senderId: _userId,
                                    reseverId: delevaryId,
                                    reseverName: delevaryName,
                                    reseverImage: photoUrl,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CircleAvatar(
                                  radius: screenWidth * 0.1,
                                  backgroundImage: photoUrl,
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  delevaryName,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.05),
                                ),
                                Spacer(
                                  flex: 3,
                                ),
                                Text(
                                  distance.toStringAsFixed(2) + ' km',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.05),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ));
            },
          );
  }
}
