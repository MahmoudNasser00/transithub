import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:transithub/Account%20manegement/Account_manage_API.dart';
import 'package:transithub/Screens/Home%20Screen.dart';
import 'package:transithub/Widget/build_text_field.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    super.key,
    // required this.verificationId,
    required this.Name,
    required this.Email,
    required this.Password,
    required this.PhoneNumber,
    required this.ImageCardID,
    required this.IdCardNumber,
    required this.BirthDate,
  });

  // final String verificationId;
  final String Name;
  final String Email;
  final String Password;
  final String PhoneNumber;
  final File ImageCardID;
  final String IdCardNumber;
  final String BirthDate;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _OTPController = TextEditingController();
  XFile? pickImage;
  late File fileProfile;
  bool isLoading = false;

  void _showImagePickerError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to pick image. Please try again.'),
      ),
    );
  }

  void _upLodeImageProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      await UserImageManager.uploadUserImage(
        fileProfile,
        (success, message) {
          if (success) {
            setState(() {
              isLoading = false;
            });
            // Registration succeeded
            print(message);
            // Show a success message to the user
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else {
            // Registration failed
            print(message);
            // Show an error message to the user
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: Text(message),
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
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      // Handle general error
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

  void _loginUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      await LoginManager(http.Client()).loginUser(
        userEmail: widget.Email,
        password: widget.Password,
        completion: (success, message) {
          if (success) {
            setState(() {
              isLoading = false;
            });
            print('object');
            _upLodeImageProfile();
          }
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text("$e"),
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
  }

  void _registerUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      await AddAccountManager().registerUser(
        userName: widget.Name,
        password: widget.Password,
        email: widget.Email,
        phoneNumber: widget.PhoneNumber,
        cardImageFile: widget.ImageCardID,
        dateOfBirth: widget.BirthDate,
        userCardId: widget.IdCardNumber,
        completion: (success, message) {
          if (success) {
            setState(() {
              isLoading = false;
            });
            // Registration succeeded
            print(message);
            // Show a success message to the user
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
            _loginUser();
          } else {
            // Registration failed
            print(message);
            // Show an error message to the user
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: Text(message),
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
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      // Handle general error
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

  // void _signInWithPhoneNumber() async {
  //   final credential = PhoneAuthProvider.credential(
  //     verificationId: widget.verificationId,
  //     smsCode: _OTPController.text,
  //   );
  //
  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Successfully signed in!')));
  //     _registerUser();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
  //   }
  // }

  Future<void> getImageProfile(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        fileProfile = File(pickedImage.path);
        setState(() {
          pickImage = pickedImage;
        });
      }
    } catch (e) {
      _showImagePickerError();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildAlertDialogContent(double screenWidth) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImagePickerButton(
            screenWidth: screenWidth,
            text: 'Take photo',
            icon: CupertinoIcons.photo_camera,
            onPressed: () async {
              await getImageProfile(ImageSource.camera);
            },
          ),
          _buildImagePickerButton(
            screenWidth: screenWidth,
            text: 'Select photo',
            icon: CupertinoIcons.photo,
            onPressed: () async {
              await getImageProfile(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required double screenWidth,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * .045,
              color: Colors.black,
            ),
          ),
          Icon(
            icon,
            size: screenWidth * 0.06,
            color: Colors.black,
          )
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
        title: const Text('Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.005,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                //================User Image Profile================
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: _buildAlertDialogContent(screenWidth),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.30,
                    width: screenHeight * 0.30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pickImage != null
                          ? Colors.transparent
                          : Colors.grey[200],
                      image: pickImage != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(pickImage!.path)),
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                //================Verification Code================
                BuildTextField(
                  label: "Verification code",
                  hint: "Enter OTP",
                  keyboardType: TextInputType.number,
                  TextSize: screenWidth * 0.05,
                  controller: _OTPController,
                  width: screenWidth * 0.45,
                  axis: 'row',
                  MaxLenght: 6,
                ),
                SizedBox(height: screenHeight * 0.08),
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
                            _registerUser();
                            // _signInWithPhoneNumber();
                          },
                          child: Text(
                            'Create',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.05),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
