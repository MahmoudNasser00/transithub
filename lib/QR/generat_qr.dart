// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
//
// class GenerateCodePage extends StatefulWidget {
//   const GenerateCodePage({
//     super.key,
//     required this.delevaryId,
//     required this.senderId,
//     required this.price,
//   });
//   final String delevaryId;
//   final String senderId;
//   final String price;
//   @override
//   State<GenerateCodePage> createState() => _GenerateCodePageState();
// }
//
// class _GenerateCodePageState extends State<GenerateCodePage> {
//   late String qrData;
//
//   @override
//   void initState() {
//     super.initState();
//     qrData =
//     'SenderId:${widget.senderId}\nDelevaryId:${widget.delevaryId}\nCost:${widget.price}';
//   }
//
//   Future<void> _saveQR() async {
//     try {
//       RenderRepaintBoundary boundary =
//       globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       var image = await boundary.toImage(pixelRatio: 3);
//       ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
//       Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//       final directory = await getTemporaryDirectory();
//       final file = File('${directory.path}/qr_code.png');
//       await file.writeAsBytes(pngBytes);
//
//       final result = await ImageGallerySaver.saveFile(file.path);
//       print("Image saved: $result");
//     } catch (e) {
//       print("Error saving image: $e");
//     }
//   }
//
//   Future<void> _shareQR() async {
//     try {
//       RenderRepaintBoundary boundary =
//       globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       var image = await boundary.toImage(pixelRatio: 3);
//       ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
//       Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//       final tempDir = await getTemporaryDirectory();
//       final file = await File('${tempDir.path}/qr_code.png').create();
//       await file.writeAsBytes(pngBytes);
//
//       await Share.shareXFiles([XFile(file.path)], text: 'This QR code contains delivery details.'); // استبدال طريقة المشاركة
//     } catch (e) {
//       print("Error sharing image: $e");
//     }
//   }
//
//   GlobalKey globalKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: screenWidth,
//           height: screenWidth,
//           child: RepaintBoundary(
//             key: globalKey,
//             child: Container(
//               padding: EdgeInsets.all(
//                 screenWidth * 0.16,
//               ),
//               color: Colors.white,
//               child: PrettyQrView.data(data: qrData),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.only(
//           left: screenWidth * 0.11,
//           right: screenWidth * 0.11,
//           bottom: screenWidth * 0.04,
//         ),
//         child: Container(
//           padding: EdgeInsets.only(
//             left: screenWidth * 0.038,
//             right: screenWidth * 0.038,
//             bottom: screenWidth * 0.019,
//             top: screenWidth * 0.019,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadiusDirectional.circular(50),
//             color: const Color.fromRGBO(198, 216, 255, 1),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               CupertinoButton(
//                 padding: EdgeInsets.all(screenWidth * 0.024),
//                 borderRadius: BorderRadius.circular(50),
//                 color: const Color.fromRGBO(236, 254, 255, 1),
//                 onPressed: _saveQR,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Save as image',
//                       style: TextStyle(color: Color.fromRGBO(0, 83, 44, 1)),
//                     ),
//                     SizedBox(
//                       width: screenWidth * 0.012,
//                     ),
//                     const Icon(
//                       Icons.arrow_circle_down,
//                       color: Color.fromRGBO(0, 83, 44, 1),
//                     )
//                   ],
//                 ),
//               ),
//               CupertinoButton(
//                 padding: EdgeInsets.all(screenWidth * 0.024),
//                 borderRadius: BorderRadius.circular(50),
//                 color: const Color.fromRGBO(236, 254, 255, 1),
//                 onPressed: _shareQR,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Share',
//                       style: TextStyle(color: Color.fromRGBO(0, 83, 44, 1)),
//                     ),
//                     SizedBox(
//                       width: screenWidth * 0.012,
//                     ),
//                     const Icon(
//                       Icons.share_rounded,
//                       color: Color.fromRGBO(0, 83, 44, 1),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

class GenerateCodePage extends StatefulWidget {
  const GenerateCodePage({
    super.key,
    required this.delevaryId,
    required this.senderId,
    required this.price,
  });

  final String delevaryId;
  final String senderId;
  final String price;

  @override
  State<GenerateCodePage> createState() => _GenerateCodePageState();
}

class _GenerateCodePageState extends State<GenerateCodePage> {
  late String qrData;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    qrData =
        'SenderId:${widget.senderId}\nDelevaryId:${widget.delevaryId}\nCost:${widget.price}';
  }

  // التحقق من الأذونات
  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied!')),
        );
        return;
      }
    }
    _saveQR(); // بعد التأكد من الأذونات، يتم حفظ الصورة
  }

  // حفظ الـ QR Code في المعرض
  Future<void> _saveQR() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // استخدام saver_gallery لحفظ الصورة
      final result = await SaverGallery.saveImage(Uint8List.fromList(pngBytes),
          fileName: 'My QR Codes', skipIfExists: false);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image saved successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save image.")));
      }
    } catch (e) {
      print("Error saving image: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error saving image.")));
    }
  }

  // مشاركة الـ QR Code
  Future<void> _shareQR() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)],
          text: 'This QR code contains delivery details.');
    } catch (e) {
      print("Error sharing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenWidth,
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              padding: EdgeInsets.all(
                screenWidth * 0.16,
              ),
              color: Colors.white,
              child: PrettyQrView.data(data: qrData),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.11,
          right: screenWidth * 0.11,
          bottom: screenWidth * 0.04,
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: screenWidth * 0.038,
            right: screenWidth * 0.038,
            bottom: screenWidth * 0.019,
            top: screenWidth * 0.019,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(50),
            color: const Color.fromRGBO(198, 216, 255, 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoButton(
                padding: EdgeInsets.all(screenWidth * 0.024),
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromRGBO(236, 254, 255, 1),
                onPressed: _checkPermissions,
                // التحقق من الأذونات قبل الحفظ
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Save as image',
                      style: TextStyle(color: Color.fromRGBO(0, 83, 44, 1)),
                    ),
                    SizedBox(
                      width: screenWidth * 0.012,
                    ),
                    const Icon(
                      Icons.arrow_circle_down,
                      color: Color.fromRGBO(0, 83, 44, 1),
                    )
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.all(screenWidth * 0.024),
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromRGBO(236, 254, 255, 1),
                onPressed: _shareQR,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Share',
                      style: TextStyle(color: Color.fromRGBO(0, 83, 44, 1)),
                    ),
                    SizedBox(
                      width: screenWidth * 0.012,
                    ),
                    const Icon(
                      Icons.share_rounded,
                      color: Color.fromRGBO(0, 83, 44, 1),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
