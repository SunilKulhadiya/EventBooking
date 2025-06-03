import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Controller/paystackcontroller.dart';
import 'package:webview_flutter/webview_flutter.dart';

int verifyPaystack = -1;
class Paystackweb extends StatefulWidget {
  final String? url;
  final String skID;
  const Paystackweb({Key? key, this.url, required this.skID, }) : super(key: key);

  @override
  State<Paystackweb> createState() => _PaystackwebState();
}

class _PaystackwebState extends State<Paystackweb> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? accessToken;
  bool isLoading = true;

  String? payerID;
  var progress;

  late final WebViewController controller;
  final notificationId = UniqueKey().hashCode;

  PaystackController paystackController = Get.put(PaystackController());

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          // onPageFinished: (e) {
          //   setState(() {
          //     isLoading = false;
          //   });
          //   paystackController.paystackCheck(skKey: widget.skID).then((value) {
          //     print("PAYMENT STATUS Response: >>>>>>>>>>>>>>>> ${value["status"]}");
          //     if(value["status"] == true){
          //       verifyPaystack = 1;
          //       Get.back();
          //     } else {
          //       verifyPaystack = 0;
          //     }
          //   },);
          // },
          // onProgress: (val) {
          //   progress = val;
          //   setState(() {});
          // },
          onNavigationRequest: (NavigationRequest request) async {
            final uri = Uri.parse(request.url);
            print("PAYSTACK RESPONSE ${uri.queryParametersAll}");
            print("PAYSTACK URL  ${uri.queryParameters["status"]}");
            var status = uri.queryParameters["status"];

            if (uri.queryParameters["status"] == null) {
              accessToken = uri.queryParametersAll["trxref"].toString();
            } else {
              if (status == "success") {
                payerID = uri.queryParametersAll["trxref"].toString();
                Get.back(result: payerID);
              } else {
                Get.back();
                ApiWrapper.showToastMessage("${uri.queryParameters["status"]}");
              }
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse("${widget.url}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
