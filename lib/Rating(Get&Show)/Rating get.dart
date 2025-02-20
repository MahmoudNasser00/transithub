import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Account manegement/Account_manage_API.dart';

class RatingScreen extends StatefulWidget {
  final String id;

  const RatingScreen({Key? key, required this.id}) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 0;
  int oneStar = 0;
  int twoStars = 0;
  int threeStars = 0;
  int fourStars = 0;
  int fiveStars = 0;

  @override
  void initState() {
    super.initState();
    _loadRating();
    setState(() {});
  }

  _loadRating() async {
    await RateManager().getRate(Id: widget.id);
    oneStar = int.parse(await Access().getOneStar() ?? '0');
    twoStars = int.parse(await Access().getTwoStars() ?? '0');
    threeStars = int.parse(await Access().getThreeStars() ?? '0');
    fourStars = int.parse(await Access().getFourStars() ?? '0');
    fiveStars = int.parse(await Access().getFiveStars() ?? '0');
    setState(() {});
  }

  _ratingUpDate() async {
    String travelerId = widget.id;
    if (_rating == 1) {
      oneStar += 1;
      await RateManager().addRate(
          travelerId: travelerId,
          oneStar: '$oneStar',
          twoStars: '$twoStars',
          threeStars: '$threeStars',
          fourStars: '$fourStars',
          fiveStars: '$fiveStars');
    } else if (_rating == 2) {
      twoStars += 1;
      await RateManager().addRate(
          travelerId: travelerId,
          oneStar: '$oneStar',
          twoStars: '$twoStars',
          threeStars: '$threeStars',
          fourStars: '$fourStars',
          fiveStars: '$fiveStars');
    } else if (_rating == 3) {
      threeStars += 1;
      await RateManager().addRate(
          travelerId: travelerId,
          oneStar: '$oneStar',
          twoStars: '$twoStars',
          threeStars: '$threeStars',
          fourStars: '$fourStars',
          fiveStars: '$fiveStars');
    } else if (_rating == 4) {
      fourStars += 1;
      await RateManager().addRate(
          travelerId: travelerId,
          oneStar: '$oneStar',
          twoStars: '$twoStars',
          threeStars: '$threeStars',
          fourStars: '$fourStars',
          fiveStars: '$fiveStars');
    } else if (_rating == 5) {
      fiveStars += 1;
      await RateManager().addRate(
          travelerId: travelerId,
          oneStar: '$oneStar',
          twoStars: '$twoStars',
          threeStars: '$threeStars',
          fourStars: '$fourStars',
          fiveStars: '$fiveStars');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select The Rate'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: _rating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 40,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actions: _rating > 0
          ? [
              Center(
                child: TextButton(
                  onPressed: () {
                    _ratingUpDate();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ),
            ]
          : [],
    );
  }
}
