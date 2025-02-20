import 'package:flutter/material.dart';
import 'package:transithub/Account%20manegement/Account_manage_API.dart';
import 'package:transithub/Payment/PaymentWebViewScreen.dart';
import 'package:transithub/Payment/paymob_service.dart';
import 'package:transithub/Widget/build_text_field.dart';

class Pay extends StatefulWidget {
  final String delevaryId;

  const Pay({super.key, required this.delevaryId});

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  final TextEditingController _firstCostController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  final TextEditingController _totalCostController = TextEditingController();

  bool isOutCountry = false;
  double commission = 0.0;
  double totalCost = 0.0;
  bool? isPayByCard = true; // Default to card payment

  late String payType = 'card';

  @override
  void initState() {
    super.initState();
    _firstCostController.addListener(_calculateCost);
  }

  @override
  void dispose() {
    _firstCostController.removeListener(_calculateCost);
    _firstCostController.dispose();
    _commissionController.dispose();
    _totalCostController.dispose();
    super.dispose();
  }

  void updateCommission(double newCommission) {
    setState(() {
      commission = newCommission;
      _commissionController.text = '$commission EG';
    });
  }

  void updateTotalCost(double newTotalCost) {
    setState(() {
      totalCost = newTotalCost;
      _totalCostController.text = '$totalCost EG';
    });
  }

  void _handleRadioValueChange(bool? value) {
    setState(() {
      isOutCountry = value!;
      _calculateCost();
    });
  }

  void _calculateCost() {
    double inputCost = double.tryParse(_firstCostController.text) ?? 0.0;
    if (isOutCountry) {
      // Out country
      updateCommission(150.0);
      updateTotalCost(inputCost + 150.0);
    } else {
      // In country
      if (inputCost <= 150) {
        updateCommission(5.0);
      } else if (inputCost <= 600) {
        updateCommission(10.0);
      } else {
        updateCommission(15.0);
      }
      updateTotalCost(inputCost + commission);
    }
  }

  Future<void> _pay() async {
    String? userId = await Access().getUserId();
    final amountCents =
        (double.tryParse(_totalCostController.text.split(' ')[0]) ?? 0) * 100;
    if (amountCents > 0) {
      final payMobService = PayMobService(
        apiKey:
            'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RjME1EY3pMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkud1dVU0pCa2xGeVN3WGpDVlc2dTh6emN3OFA1QTNyVUxKVEpVMGlneWRnUlhjdmlQb0dHbmZ0YldsbkdGUEFaMU45WHZpaDFuZlZPM2laNWZWYTdJckE=',
        integrationId: '4566640',
        redirectUrl:
            'https://accept.paymobsolutions.com/api/acceptance/post_pay',
      );

      try {
        final paymentToken =
            await payMobService.createPayment(amountCents.toString());
        final paymentUrl =
            'https://accept.paymob.com/api/acceptance/iframes/842132?payment_token=$paymentToken';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebViewScreen(
              paymentUrl: paymentUrl,
              delevaryId: widget.delevaryId,
              price: _totalCostController.text,
              senderId: userId!,
            ),
          ),
        );
      } catch (e) {
        print(e);
        // عرض رسالة خطأ للمستخدم
        _showErrorDialog('Failed to create payment order. Please try again.');
      }
    } else {
      _showErrorDialog('Invalid amount. Please enter a valid cost.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.02),
        children: [
          SizedBox(
            height: screenHeight * 0.45,
            child: Image.asset('assets/images/Boxes.png'),
          ),
          BuildTextField(
            label: 'Delivery service cost',
            hint: 'Enter the cost',
            keyboardType: TextInputType.number,
            controller: _firstCostController,
            TextSize: screenWidth * 0.052,
            width: screenWidth * 0.4,
            axis: 'row',
          ),
          Text(
            "Delivery type",
            style: TextStyle(fontSize: screenWidth * 0.052),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio<bool>(
                    activeColor: const Color.fromRGBO(84, 137, 255, 1),
                    value: true,
                    groupValue: isOutCountry,
                    onChanged: _handleRadioValueChange,
                  ),
                  Text(
                    'out country',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                    ),
                  )
                ],
              ),
              SizedBox(width: screenWidth * 0.05),
              Row(
                children: [
                  Radio<bool>(
                    activeColor: const Color.fromRGBO(84, 137, 255, 1),
                    value: false,
                    groupValue: isOutCountry,
                    onChanged: _handleRadioValueChange,
                  ),
                  Text(
                    'in country',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                    ),
                  )
                ],
              ),
            ],
          ),
          BuildTextField(
            label: 'Commission',
            hint: 'Commission',
            keyboardType: TextInputType.number,
            TextSize: screenWidth * 0.052,
            width: screenWidth * 0.4,
            controller: _commissionController,
            read: true,
            axis: 'row',
          ),
          Divider(
            indent: screenWidth * 0.06,
            endIndent: screenWidth * 0.06,
            height: screenHeight * 0.04,
            thickness: 0,
          ),
          Text(
            'A commission of 5 EG is added to each trip whose cost does not exceed 150 EG, 10 EG for each trip whose cost does not exceed 600 EG, and 15 EG for all other trips except those outside the country, which cost 150 EG.',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
            ),
            textAlign: TextAlign.center,
          ),
          Divider(
            indent: screenWidth * 0.06,
            endIndent: screenWidth * 0.06,
            height: screenHeight * 0.04,
            thickness: screenWidth * 0.005,
          ),
          Text(
            'Pay Type',
            style: TextStyle(
              fontSize: screenWidth * 0.052,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio<bool>(
                    activeColor: const Color.fromRGBO(84, 137, 255, 1),
                    value: true,
                    groupValue: isPayByCard,
                    onChanged: (value) {
                      // No need to handle as it's the only option now
                    },
                  ),
                  Text(
                    'Pay by Card',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                    ),
                  )
                ],
              ),
            ],
          ),
          BuildTextField(
            label: 'Total cost',
            hint: 'Total cost',
            keyboardType: TextInputType.number,
            TextSize: screenWidth * 0.052,
            width: screenWidth * 0.3,
            controller: _totalCostController,
            read: true,
            axis: 'row',
          ),
          Padding(
            padding: EdgeInsets.only(
              left: (screenWidth / 2) - (screenWidth * 0.6) / 2,
              right: (screenWidth / 2) - (screenWidth * 0.6) / 2,
              top: screenHeight * 0.02,
              bottom: screenHeight * 0.05,
            ),
            child: ElevatedButton(
              onPressed: _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(84, 137, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.015,
                  vertical: screenHeight * 0.015,
                ),
              ),
              child: Text(
                'Complete the Payment',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
