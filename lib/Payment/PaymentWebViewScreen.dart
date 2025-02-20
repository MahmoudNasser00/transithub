// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//
// class PaymentWebViewScreen extends StatefulWidget {
//   final String paymentUrl;
//
//   PaymentWebViewScreen({required this.paymentUrl});
//
//   @override
//   _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
// }
//
// class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     final WebViewController controller =
//         WebViewController.fromPlatformCreationParams(params);
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..loadRequest(Uri.parse(widget.paymentUrl));
//
//     _controller = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment'),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:transithub/Account%20manegement/Account_manage_API.dart';
import 'package:transithub/QR/generat_qr.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String delevaryId;
  final String senderId;
  final String price;

  PaymentWebViewScreen(
      {required this.paymentUrl,
      required this.delevaryId,
      required this.senderId,
      required this.price});

  @override
  _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          if (url.contains("success")) {
            QrCreateManager().createQR(
                qrCode:
                    'SenderId:${widget.senderId} , DelevaryId:${widget.delevaryId} , Cost:${widget.price}',
                senderId: widget.senderId,
                carrierId: widget.delevaryId,
                price: widget.price);
            // فتح صفحة جديدة عند النجاح
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenerateCodePage(
                    delevaryId: widget.delevaryId,
                    senderId: widget.senderId,
                    price: widget.price),
              ),
            );
          } else if (url.contains("failure")) {
            // فتح صفحة جديدة عند الفشل
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FailurePage(),
              ),
            );
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

class FailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('There was an error with your payment.')),
    );
  }
}
