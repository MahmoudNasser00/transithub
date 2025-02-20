import 'package:flutter/material.dart';
import 'package:rating_summary/rating_summary.dart';

import '../Account manegement/Account_manage_API.dart';

class RatingShow extends StatefulWidget {
  final String id;

  const RatingShow({Key? key, required this.id}) : super(key: key);

  @override
  _RatingShowState createState() => _RatingShowState();
}

class _RatingShowState extends State<RatingShow> {
  int oneStar = 0;
  int twoStars = 0;
  int threeStars = 0;
  int fourStars = 0;
  int fiveStars = 0;
  int totalRatings = 0;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      await RateManager().getRate(Id: widget.id);
      oneStar = int.tryParse(await Access().getOneStar() ?? '0') ?? 0;
      twoStars = int.tryParse(await Access().getTwoStars() ?? '0') ?? 0;
      threeStars = int.tryParse(await Access().getThreeStars() ?? '0') ?? 0;
      fourStars = int.tryParse(await Access().getFourStars() ?? '0') ?? 0;
      fiveStars = int.tryParse(await Access().getFiveStars() ?? '0') ?? 0;
      totalRatings = oneStar + twoStars + threeStars + fourStars + fiveStars;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Handle error
      print('Error fetching rating data: $e');
    }
  }

  double average() {
    if (totalRatings == 0) {
      return 0;
    }
    return (5 * fiveStars +
            4 * fourStars +
            3 * threeStars +
            2 * twoStars +
            1 * oneStar) /
        totalRatings;
  }

  @override
  Widget build(BuildContext context) {
    return totalRatings == 0
        ? Center(child: Text('No ratings available'))
        : RatingSummary(
            labelCounterFiveStars: Text("⭐⭐⭐⭐⭐"),
            labelCounterFourStars: Text("⭐⭐⭐⭐"),
            labelCounterThreeStars: Text("⭐⭐⭐"),
            labelCounterTwoStars: Text("⭐⭐"),
            labelCounterOneStars: Text("⭐"),
            average: average(),
            counter: totalRatings,
            counterFiveStars: fiveStars,
            counterFourStars: fourStars,
            counterThreeStars: threeStars,
            counterTwoStars: twoStars,
            counterOneStars: oneStar,
          );
  }
}
