import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:transithub/Chat/chat_screen.dart';

import '../Account manegement/Account_manage_API.dart';
import "../Screens/Traveler's profile&Details trip/Details trip.dart";

class PositionParts {
  final String part1;
  final String part2;

  PositionParts(this.part1, this.part2);
}

PositionParts splitString(String userPosition) {
  List<String> parts = userPosition.split(',');
  return PositionParts(parts[0], parts[1]);
}

class LocalPostWidgetShow extends StatefulWidget {
  @override
  _LocalPostWidgetShowState createState() => _LocalPostWidgetShowState();
}

class _LocalPostWidgetShowState extends State<LocalPostWidgetShow> {
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
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder<List<Map<String, dynamic>>>(
            future: localTripManager.getAllLocalTrips(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No local trips available'));
              }

              final localTrips = snapshot.data!;

              return Container(
                width: screenWidth,
                height: screenHeight * .1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: localTrips.length,
                  itemBuilder: (context, index) {
                    final trip = localTrips[index];
                    final from = trip['from'] as String? ?? '';
                    final to = trip['to'] as String? ?? '';
                    final vehicleType = trip['vehicleType'] as String? ?? '';
                    final position = trip['position'] as String? ?? '';
                    final name = trip['userName'] as String? ?? '';
                    final photoUrl = NetworkImage(trip['imageUrl'] as String? ??
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
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenWidth * 0.01,
                        ),
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
                                  reseverName: name,
                                  reseverImage: photoUrl,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.08,
                                backgroundImage: photoUrl,
                              ),
                              Positioned(
                                bottom: -5,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            },
          );
  }
}

class DateTimeParts {
  final String datePart;
  final String timePart;

  DateTimeParts(this.datePart, this.timePart);
}

DateTimeParts splitDateTime(String dateTime) {
  List<String> parts = dateTime.split('T');
  return DateTimeParts(parts[0], parts[1]);
}

class PostWidgetShow extends StatelessWidget {
  final TripManager tripManager = TripManager();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: tripManager.getAllTripsWithUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No trips available'));
        }

        final trips = snapshot.data!;

        return SizedBox(
          height: screenHeight,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              final name = trip['userName'] as String? ?? '';
              final from = trip['from'] as String? ?? '';
              final to = trip['to'] as String? ?? '';
              final time = trip['tripTime'] as String? ?? '';
              final type = trip['viechelType'] as String? ?? '';
              final delevaryId = trip['userId'] as String? ?? '';
              final numberOftTrip = trip['tripNumber'] as String? ?? '';
              final photo = NetworkImage(trip['personalImgUrl'] as String? ??
                  'https://via.placeholder.com/150');

              DateTimeParts parts = splitDateTime(time);
              String datePart = parts.datePart;
              String timePart = parts.timePart;

              String convertDate(String inputDate) {
                DateFormat originalFormat = DateFormat('yyyy-MM-dd');
                DateFormat newFormat = DateFormat('dd/MM/yyyy');
                DateTime dateTime = originalFormat.parse(inputDate);
                String formattedDate = newFormat.format(dateTime);
                return formattedDate;
              }

              String convertTimeTo12HourFormat(String time) {
                final DateFormat inputFormat = DateFormat("HH:mm:ss");
                final DateFormat outputFormat = DateFormat("hh:mm a");
                final DateTime dateTime = inputFormat.parse(time);
                final String formattedTime = outputFormat.format(dateTime);
                return formattedTime;
              }

              // Convert the date to DateTime object and compare it with current date
              DateTime tripDate =
                  DateFormat('dd/MM/yyyy').parse(convertDate(datePart));
              DateTime currentDate = DateFormat('dd/MM/yyyy')
                  .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));

              if (currentDate.isBefore(tripDate)) {
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
                          builder: (context) => DetailsTrip(
                            from: from,
                            to: to,
                            tripTime: convertTimeTo12HourFormat(timePart),
                            tripDate: convertDate(datePart),
                            transportionType: type,
                            travelerId: delevaryId,
                            numberOfTrip: numberOftTrip,
                            travelerName: name,
                            travelerImage: photo,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.03),
                        color: const Color.fromRGBO(200, 223, 233, 1),
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.043),
                      width: screenWidth * 0.95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: $delevaryId"),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: photo,
                              ),
                              SizedBox(width: screenWidth * 0.036),
                              Text(name,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.049)),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('From: $from',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04)),
                                    SizedBox(height: screenHeight * 0.006),
                                    Text('Type of Trip: $type',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('To: $to',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04)),
                                    SizedBox(height: screenHeight * 0.006),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.006),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date: ${convertDate(datePart)}',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04)),
                              Text(
                                  'Time: ${convertTimeTo12HourFormat(timePart)}',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}
