import 'package:flutter/material.dart';
import 'package:transithub/QR/generat_qr.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final String senderId;
  final String delevaryId;
  final String price;

  const PaymentScreen(
      {super.key,
      required this.paymentUrl,
      required this.senderId,
      required this.delevaryId,
      required this.price});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    _launchPaymentUrl();
  }

  Future<void> _launchPaymentUrl() async {
    try {
      if (await canLaunchUrlString(widget.paymentUrl)) {
        await launchUrlString(widget.paymentUrl);
        _checkPaymentCompletion();
      } else {
        throw 'Could not launch ${widget.paymentUrl}';
      }
    } catch (e) {
      print(e);
      _showErrorDialog('Failed to launch payment URL. Please try again.');
    }
  }

  void _checkPaymentCompletion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => GenerateCodePage(
                price: widget.price,
                delevaryId: widget.delevaryId,
                senderId: widget.senderId,
              )),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
