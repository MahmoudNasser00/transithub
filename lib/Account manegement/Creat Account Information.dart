import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transithub/Widget/build_date_field.dart';
import 'package:transithub/Widget/build_password_text_field.dart';
import 'package:transithub/Widget/build_text_field.dart';

import 'Account_manage_API.dart';
import 'VerificationScreen.dart';

class CreateAccountInformation extends StatefulWidget {
  const CreateAccountInformation({super.key});

  @override
  _CreateAccountInformationState createState() =>
      _CreateAccountInformationState();
}

class _CreateAccountInformationState extends State<CreateAccountInformation> {
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  XFile? pickImage;
  XFile? pickImageCardID;
  late File fileProfile;
  late File fileCard;
  bool isLoading = false;

  Future<void> getImageCardID(ImageSource source) async {
    try {
      final pickedImageCardID = await ImagePicker().pickImage(source: source);
      if (pickedImageCardID != null) {
        fileCard = File(pickedImageCardID.path);
      }
      if (pickedImageCardID != null) {
        setState(() {
          pickImageCardID = pickedImageCardID;
        });
      }
    } catch (e) {
      _showImagePickerError();
    }
  }

  void _showImagePickerError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to pick image. Please try again.'),
      ),
    );
  }

  // تعديل دالة التحقق من رقم الهاتف لتضمين reCAPTCHA
  // void _verifyPhoneNumber({String? phoneNumber}) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   String fullPhoneNumber = phoneNumber ?? _phoneNumberController.text;
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: fullPhoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       if (e.code == 'invalid-phone-number') {
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) => AlertDialog(
  //             title: const Text('Error'),
  //             content: Text("Invalid phone number"),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => VerificationScreen(
  //             verificationId: verificationId,
  //             PhoneNumber: fullPhoneNumber,
  //             Name: _NameController.text,
  //             BirthDate: _dateController.text,
  //             Email: _EmailController.text,
  //             Password: _PasswordController.text,
  //             IdCardNumber: _idController.text,
  //             ImageCardID: fileCard,
  //           ),
  //         ),
  //       );
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  // }

  // البحث عن البريد الإلكتروني
  void _searchEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      await AccountSearchManager().searchAccount(
        email: _EmailController.text,
        completion: (success, message, {String? phoneNumber}) {
          setState(() {
            isLoading = false;
          });

          if (success) {
            // البريد الإلكتروني موجود
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Information'),
                content: Text("$message\nChoose another email"),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          } else {
            // البريد الإلكتروني غير موجود، تحقق من رقم الهاتف
            // _verifyPhoneNumber(phoneNumber: phoneNumber);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  // verificationId: verificationId,
                  // PhoneNumber: fullPhoneNumber,
                  PhoneNumber: _phoneNumberController.text,
                  Name: _NameController.text,
                  BirthDate: _dateController.text,
                  Email: _EmailController.text,
                  Password: _PasswordController.text,
                  IdCardNumber: _idController.text,
                  ImageCardID: fileCard,
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      }); // معالجة الخطأ العام
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: <Widget>[
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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create new account',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.005,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: screenHeight * 0.0112,
          children: [
            //================Logo================
            Center(
              child: SizedBox(
                height: screenHeight * 0.39,
                width: screenWidth * 0.83,
                child: Image.asset('assets/images/Logo Light.png'),
              ),
            ),
            //================name================
            BuildTextField(
              TextSize: screenWidth * .05,
              width: screenWidth,
              label: "Name as on ID card",
              hint: "Enter your name",
              keyboardType: TextInputType.name,
              controller: _NameController,
            ),
            //================date================
            BuildDateField(
              width: screenWidth,
              height: screenHeight,
              label: "Date of birth as on ID card",
              controller: _dateController,
            ),
            //================email================
            BuildTextField(
              TextSize: screenWidth * .05,
              width: screenWidth,
              label: "Email",
              hint: "Enter email",
              keyboardType: TextInputType.emailAddress,
              icon: CupertinoIcons.mail,
              controller: _EmailController,
            ),
            //================password================
            BuildPasswordTextField(
              TextSize: screenWidth * .05,
              width: screenWidth,
              controller: _PasswordController,
            ),
            //================phone number================
            BuildTextField(
              TextSize: screenWidth * .05,
              label: "Phone Number",
              hint: "Enter phone number",
              keyboardType: TextInputType.phone,
              icon: CupertinoIcons.phone,
              width: screenWidth,
              controller: _phoneNumberController,
              MaxLenght: 13,
            ),
            //================ID number================
            BuildTextField(
              TextSize: screenWidth * .05,
              label: "ID card number",
              hint: "Enter ID card number",
              keyboardType: TextInputType.number,
              icon: Icons.call_to_action_outlined,
              width: screenWidth,
              controller: _idController,
              MaxLenght: 14,
            ),
            //================ID Card image================
            _buildUploadButton(screenHeight, screenWidth),
            //================Create Account================
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                              Color.fromRGBO(133, 209, 209, 1)),
                          shape: WidgetStatePropertyAll(
                            ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(50000),
                            ),
                          ),
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.01),
                          )),
                      onPressed: () {
                        _searchEmail();
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            color: Colors.black, fontSize: screenWidth * 0.05),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(double screenHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Upload a Photo for ID card',
          style: TextStyle(fontSize: screenWidth * 0.048),
        ),
        CupertinoButton(
          padding: EdgeInsetsDirectional.only(
            bottom: screenHeight * 0.01,
            start: screenWidth * 0.03,
            end: screenWidth * 0.03,
            top: screenHeight * 0.01,
          ),
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromRGBO(133, 209, 209, 1),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Upload',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_circle_up,
                color: Colors.black,
              ),
            ],
          ),
          onPressed: () async {
            await getImageCardID(ImageSource.camera);
          },
        ),
      ],
    );
  }
}
