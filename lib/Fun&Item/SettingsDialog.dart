import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transithub/Account%20manegement/Account_manage_API.dart';
import 'package:transithub/Rating(Get&Show)/Ratig%20show.dart';
import 'package:transithub/Rating(Get&Show)/Rating%20get.dart';

import '../Account manegement/LogIn Screen.dart';

class SettingsDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late Future<String?> _userName;
  late Future<String?> _userEmail;
  late Future<String?> _userPhone;
  late Future<String?> _userImageUrl;
  String? _userId;
  XFile? pickImage;
  File? fileProfile; // Nullable

  @override
  void initState() {
    super.initState();
    _userName = Access().getUserName();
    _userEmail = Access().getUserEmail();
    _userPhone = Access().getUserPhone();
    _userImageUrl = Access().getUserImageProfileUrl();
    _initializeUserData();
    setState(() {});
  }

  Future<void> _initializeUserData() async {
    _userId = await Access().getUserId();
    UserImageManager.getUserImageById(userId: _userId!);
  }

  Future<void> getImageProfile(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          fileProfile = File(pickedImage.path);
        });
        await _showConfirmationDialog(fileProfile!);
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

  Future<void> _showConfirmationDialog(File imageFile) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(imageFile),
              const SizedBox(height: 20),
              const Text('Do you want to use this image?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      await UserImageManager.updateUserImage(imageFile);
      setState(() {
        _userImageUrl = Access().getUserImageProfileUrl();
      });
    }
  }

  void logOut() {
    Access().removeUserId();
    Access().removeUserEmail();
    Access().removeUserName();
    Access().removeToken();
    Access().removeUserTokenExpiry();
    Access().removeUserTripNumber();
    Access().removeUserPhone();
    Access().removeUserImageProfileUrl();
    Access().removeOneStar();
    Access().removeTwoStars();
    Access().removeThreeStars();
    Access().removeFourStars();
    Access().removeFiveStars();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  void deleteAccount() {
    Access().removeUserId();
    Access().removeUserEmail();
    Access().removeUserName();
    Access().removeToken();
    Access().removeUserTokenExpiry();
    Access().removeUserTripNumber();
    Access().removeUserPhone();
    Access().removeUserImageProfileUrl();
    Access().removeOneStar();
    Access().removeTwoStars();
    Access().removeThreeStars();
    Access().removeFourStars();
    Access().removeFiveStars();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  Widget _buildAlertDialogContent(double screenWidth) {
    return Column(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(
        screenWidth * .03,
        screenWidth * .03,
        screenWidth * .009,
        screenWidth * .03,
      ),
      insetPadding: EdgeInsets.all(screenWidth * 0.07),
      scrollable: true,
      title: const Center(
        child: Text("TransitHub"),
      ),
      content: Container(
        width: screenWidth,
        height: screenHeight * 0.6,
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    FutureBuilder<String?>(
                      future: _userImageUrl,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return CircleAvatar(
                            radius: screenWidth * 0.1,
                            child: const Icon(Icons.error_outline),
                          );
                        } else {
                          return CircleAvatar(
                            radius: screenWidth * 0.1,
                            backgroundImage: NetworkImage(snapshot.data ??
                                'https://via.placeholder.com/150'),
                          );
                        }
                      },
                    ),
                    Positioned(
                      height: screenWidth * 0.07,
                      width: screenWidth * 0.07,
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: _buildAlertDialogContent(screenWidth),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          CupertinoIcons.add_circled,
                          color: Color.fromRGBO(133, 209, 209, 1),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 16),
                FutureBuilder<String?>(
                  future: _userName,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        snapshot.data ?? 'Username not found',
                        style: TextStyle(fontSize: screenWidth * 0.055),
                      );
                    }
                  },
                ),
              ],
            ),
            ListTile(
              title: Text(
                "Phone number",
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              subtitle: FutureBuilder<String?>(
                future: _userPhone,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      snapshot.data ?? 'Phone number not found',
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    );
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                "Email",
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              subtitle: FutureBuilder<String?>(
                future: _userEmail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      snapshot.data ?? 'Email not found',
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    );
                  }
                },
              ),
            ),
            FutureBuilder<Widget>(
              future: Future.delayed(const Duration(seconds: 2), () {
                return RatingShow(id: _userId!);
              }),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return snapshot.data ?? const Text('No rating yet');
                  }
                }
              },
            ),
            SizedBox(height: screenHeight * 0.01),
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () {
                    logOut();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      Text(
                        "Log out",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RatingScreen(id: _userId!);
                        });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      Text(
                        "Delete Account",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
