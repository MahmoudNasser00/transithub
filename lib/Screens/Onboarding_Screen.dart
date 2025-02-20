import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Account manegement/LogIn Screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<String> images = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/6.png'
  ];

  final List<String> text = [
    'Whether you are tired or busy Do not worry.',
    'You can send your papers or anything else to someone, anywhere, safely.',
    'All you have to do is enter the app name, search for travelers heading to the place you want to send your things to, and talk to them.',
    'You give the item you want to send to the traveler when reaching an agreement between you and the traveler',
    'When the traveler reaches his destination, he delivers the sent item to the person or entity to whom it is sent',
    'Then the person to whom it is sent or the entity to which it is sent displays the QR that the sender sent the package to the recipient of the package. For a traveler to scan this code to confirm the delivery of the sent item'
  ];

  void _onNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % images.length;
    });
  }

  void _onBack() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % images.length;
    });
  }

  void _onDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_currentIndex > 0)
              IconButton(
                onPressed: _onBack,
                icon: Row(
                  children: [
                    Icon(CupertinoIcons.chevron_back),
                    Text('Back',
                        style: TextStyle(fontSize: screenWidth * 0.044)),
                  ],
                ),
                highlightColor: const Color.fromRGBO(133, 209, 209, 1),
              ),
            const Spacer(flex: 1),
            if (_currentIndex < images.length - 1)
              IconButton(
                onPressed: _onNext,
                icon: Row(
                  children: [
                    Text('Next',
                        style: TextStyle(fontSize: screenWidth * 0.044)),
                    Icon(CupertinoIcons.chevron_forward),
                  ],
                ),
                highlightColor: const Color.fromRGBO(133, 209, 209, 1),
              ),
            if (_currentIndex == images.length - 1)
              IconButton(
                onPressed: _onDone,
                icon: const Row(
                  children: [
                    Text('Done', style: TextStyle(fontSize: 18)),
                    Icon(CupertinoIcons.chevron_forward),
                  ],
                ),
                highlightColor: const Color.fromRGBO(133, 209, 209, 1),
              ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.019),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentIndex < images.length - 1)
                    IconButton(
                      onPressed: _onDone,
                      icon: Text('Skip',
                          style: TextStyle(fontSize: screenWidth * 0.044)),
                      highlightColor: const Color.fromRGBO(133, 209, 209, 1),
                    ),
                ],
              ),
              SizedBox(
                width: screenWidth * 0.98,
                height: screenHeight * 0.48,
                child: Image.asset(images[_currentIndex]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Text(
                    text[_currentIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: screenWidth * 0.048),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
