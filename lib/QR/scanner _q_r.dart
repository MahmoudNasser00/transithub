import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:transithub/Account%20manegement/Account_manage_API.dart';

class ScannerQR extends StatefulWidget {
  const ScannerQR({Key? key}) : super(key: key);

  @override
  _ScannerQRState createState() => _ScannerQRState();
}

class _ScannerQRState extends State<ScannerQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            print('Barcode found! ${barcode.rawValue}');
          }
          if (image != null) {
            QrScanManager().scanQR(
                qrCode: barcodes.first.rawValue ?? "",
                senderId: 'senderId', //sender id
                carrierId: 'carrierId'); // delivery id
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    barcodes.first.rawValue ?? "",
                  ),
                  content: Image(
                    image: MemoryImage(image),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
