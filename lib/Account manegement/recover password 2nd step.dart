// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transithub/Screens/Home%20Screen.dart';
import 'package:transithub/Widget/build_text_field.dart';

import '../Widget/build_password_text_field.dart';

class RecoverPasswordScreen2 extends StatefulWidget {
  final String email;
  final String verificationId;

  const RecoverPasswordScreen2({
    Key? key,
    required this.email,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<RecoverPasswordScreen2> createState() => _RecoverPasswordScreen2State();
}

class _RecoverPasswordScreen2State extends State<RecoverPasswordScreen2> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool isLoading = false;

  // التحقق من OTP وتغيير كلمة المرور
  void _verifyOtpAndChangePassword() async {
    if (_otpController.text.isEmpty || _newPasswordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields.');
      return;
    }

    setState(() => isLoading = true);
    try {
      // final credential = PhoneAuthProvider.credential(
      //   verificationId: widget.verificationId,
      //   smsCode: _otpController.text,
      // );

      // await FirebaseAuth.instance.signInWithCredential(credential);
      _showSnackBar('Password changed successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar('Failed to change password: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
              label: "Validation Code",
              hint: "Enter OTP",
              keyboardType: TextInputType.number,
              controller: _otpController,
            ),
            SizedBox(height: screenHeight * 0.02),
            BuildPasswordTextField(
              TextSize: screenWidth * .05,
              width: screenWidth,
              label: "New Password",
              hint: "Enter your new password",
              controller: _newPasswordController,
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
                      onPressed: _verifyOtpAndChangePassword,
                      child: const Text(
                        'Change Password',
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
