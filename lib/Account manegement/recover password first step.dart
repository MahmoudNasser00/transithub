// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transithub/Account%20manegement/Account_manage_API.dart';
import 'package:transithub/Account%20manegement/recover%20password%202nd%20step.dart';
import 'package:transithub/Widget/build_text_field.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({Key? key}) : super(key: key);

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  // البحث عن البريد الإلكتروني والتحقق منه
  void _searchEmail() async {
    if (_emailController.text.isEmpty || _phoneNumberController.text.isEmpty) {
      _showDialog('Error', 'Please fill in all fields.');
      return;
    }

    setState(() => isLoading = true);
    try {
      await AccountSearchManager().searchAccount(
        email: _emailController.text,
        completion: (success, message, {String? phoneNumber}) {
          setState(() => isLoading = false);

          if (success) {
            // إذا كان البريد الإلكتروني موجودًا
            if (phoneNumber != null) {
              _verifyPhoneNumber(phoneNumber);
            }
          } else {
            _showDialog('Information', "$message\nThis email doesn't exist.");
          }
        },
      );
    } catch (e) {
      setState(() => isLoading = false);
      _showDialog('Error', 'An error occurred: $e');
    }
  }

  // التحقق من صحة رقم الهاتف
  void _verifyPhoneNumber(String phoneNumber) {
    if (_phoneNumberController.text != phoneNumber) {
      _showDialog('Information', "The phone number isn't correct.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecoverPasswordScreen2(
          email: _emailController.text,
          verificationId: phoneNumber,
        ),
      ),
    );
  }

  // عرض مربعات حوار للرسائل
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
      appBar: AppBar(
        title: Text(
          'Recover Password',
          style: TextStyle(fontSize: screenWidth * 0.06),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          children: [
            CircleAvatar(
              radius: screenHeight * 0.15,
              backgroundImage: const AssetImage('assets/images/Logo Light.png'),
            ),
            BuildTextField(
              TextSize: screenWidth * .05,
              width: screenWidth,
              label: "Email",
              hint: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            SizedBox(height: screenHeight * 0.02),
            BuildTextField(
              TextSize: screenWidth * .05,
              width: screenWidth,
              label: "Phone Number",
              hint: "Enter your phone number",
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : CupertinoButton(
                      color: const Color.fromRGBO(133, 209, 209, 1),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.016,
                        horizontal: screenWidth * 0.1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      onPressed: _searchEmail,
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
