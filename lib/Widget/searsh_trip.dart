import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Account manegement/Account_manage_API.dart';
import "../Screens/Traveler's profile&Details trip/Details trip.dart";

class DateTimeParts {
  final String datePart;
  final String timePart;

  DateTimeParts(this.datePart, this.timePart);
}

DateTimeParts splitDateTime(String dateTime) {
  List<String> parts = dateTime.split('T');
  return DateTimeParts(parts[0], parts[1]);
}

class TripResultsScreen extends StatelessWidget {
  final TripManager tripManager = TripManager();
  final String startLocation;
  final String endLocation;

  TripResultsScreen({
    required this.startLocation,
    required this.endLocation,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: tripManager.getAllTripsWithUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No trips available'));
        }

        final trips = snapshot.data!.where((trip) {
          final from = trip['from'] as String? ?? '';
          final to = trip['to'] as String? ?? '';
          return from.toLowerCase().contains(startLocation.toLowerCase()) &&
              to.toLowerCase().contains(endLocation.toLowerCase());
        }).toList();

        if (trips.isEmpty) {
          return Center(child: Text('No trips match the given locations'));
        }

        return Container(
            width: screenWidth,
            height: screenHeight,
            child: ListView.builder(
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
                  return newFormat.format(dateTime);
                }

                String convertTimeTo12HourFormat(String time) {
                  final DateFormat inputFormat = DateFormat("HH:mm");
                  final DateFormat outputFormat = DateFormat("hh:mm a");
                  final DateTime dateTime = inputFormat.parse(time);
                  return outputFormat.format(dateTime);
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                  child: InkWell(
                    onLongPress: () {
                      print('see more');
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
              },
            ));
      },
    );
  }
}
