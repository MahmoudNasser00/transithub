import 'package:flutter/material.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:transithub/Screens/Splash%20Screen.dart';

// void main() async {
void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return MaterialApp(
      title: 'TransitHub',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        appBarTheme: AppBarTheme(
            foregroundColor: Colors.black,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.061,
            )),
      ),
      debugShowCheckedModeBanner: false,
      home: const Splash_Screen(),
    );
  }
}
