import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transithub/Account%20manegement/recover%20password%20first%20step.dart';
import 'package:transithub/Screens/Home%20Screen.dart';
import 'package:transithub/Widget/build_password_text_field.dart';
import 'package:transithub/Widget/build_text_field.dart';

import 'Account_manage_API.dart';
import 'Creat Account Information.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _validateInput() {
    if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
      return "Email and password are not entered";
    } else if (_emailController.text.isEmpty) {
      return 'Email not entered';
    } else if (_passwordController.text.isEmpty) {
      return 'Password not entered';
    } else {
      return "Incorrect email or password";
    }
  }

  void _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog(_validateInput());
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await LoginManager(http.Client()).loginUser(
        userEmail: _emailController.text,
        password: _passwordController.text,
        completion: (success, message) {
          setState(() {
            isLoading = false;
          });
          if (success) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else {
            _showErrorDialog(message);
          }
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.only(
            start: screenWidth * 0.036,
            end: screenWidth * 0.016,
          ),
          children: [
            SizedBox(
              height: screenHeight * 0.39,
              width: screenWidth * 0.83,
              child: Image.asset('assets/images/Logo Light.png'),
            ),
            BuildTextField(
              label: 'Email',
              hint: 'Enter email',
              icon: CupertinoIcons.mail,
              controller: _emailController,
              width: screenWidth - 25,
              keyboardType: TextInputType.emailAddress,
              TextSize: screenWidth * .05,
            ),
            SizedBox(height: screenHeight * 0.01),
            BuildPasswordTextField(
              TextSize: screenWidth * .05,
              width: screenWidth - 25,
              controller: _passwordController,
            ),
            SizedBox(height: screenHeight * 0.0112),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecoverPasswordScreen()),
                    );
                  },
                  child: Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: screenWidth * .036,
                      color: const Color.fromRGBO(0, 0, 0, .5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.0112),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : CupertinoButton(
                      padding: EdgeInsetsDirectional.only(
                        bottom: screenHeight * 0.016,
                        start: screenWidth * 0.125,
                        end: screenWidth * 0.125,
                        top: screenHeight * 0.016,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(133, 209, 209, 1),
                      onPressed: _loginUser,
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateAccountInformation()),
                  );
                },
                child: Text(
                  'Create new account',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
