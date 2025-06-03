import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:goevent2/profile/Wallet/WalletHistory.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Api/ApiWrapper.dart';
import '../Api/Config.dart';

class Senangpay extends StatefulWidget {
  final String totalAmount;
  final String name;
  final String email;
  final String phone;
  const Senangpay({Key? key, required this.totalAmount, required this.name, required this.email, required this.phone}) : super(key: key);

  @override
  State<Senangpay> createState() => _SenangpayState();
}

class _SenangpayState extends State<Senangpay> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? accessToken;
  bool isLoading = true;

  String? payerID;
  var progress;

  late final WebViewController controller;
  final notificationId = UniqueKey().hashCode;

  @override
  void initState() {
    super.initState();
    setState(() {});
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (navigation) async {
            final uri = Uri.parse(navigation.url);
            print("URL + ${uri.queryParameters}");
            if (uri.queryParameters["msg"] == null) {
              accessToken = uri.queryParameters["token"];
            } else {
              if (uri.queryParameters["msg"] == "Payment_was_successful") {
                payerID = uri.queryParameters["transaction_id"]!;
                Get.back(result: uri.queryParameters["transaction_id"]);
              } else {
                Get.to(const WalletReportPage());
                Fluttertoast.showToast(msg: "${uri.queryParameters["msg"]}",timeInSecForIosWeb: 4);
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "${Config.base_url}result.php?detail=Movers&amount=${widget.totalAmount}&order_id=$notificationId&name=${widget.name}&email=${widget.email}&phone=${widget.phone}"));
  }

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(
                  controller: controller,
                ),
              ],
            )),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back()),
            backgroundColor: Colors.black12,
            elevation: 0.0),
        body: Center(
            child: Container(
              child: CircularProgressIndicator(),
            )),
      );
    }
  }
}
