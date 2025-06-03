import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Api/ApiWrapper.dart';
import '../Api/Config.dart';

class Midtrans extends StatefulWidget {
  final String totalAmount;
  final String email;
  final String phonNumber;
  const Midtrans({Key? key, required this.totalAmount, required this.email, required this.phonNumber}) : super(key: key);

  @override
  State<Midtrans> createState() => _MidtransState();
}

class _MidtransState extends State<Midtrans> {

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
            print("${Config.base_url}Midtrans/index.php?name=test&email=${widget.email}&phone=${widget.phonNumber}&amt=${widget.totalAmount}");
            final uri = Uri.parse(navigation.url);
            print("URL + ${uri.queryParameters}");
            if (uri.queryParameters["status_code"] == null) {
              accessToken = uri.queryParameters["token"];
            } else {
              if (uri.queryParameters["status_code"] == "200") {
                payerID = await uri.queryParameters["order_id"];
                Get.back(result: payerID);
              } else {

                Get.back();

                Fluttertoast.showToast(msg: "${uri.queryParameters["transaction_status"]}",timeInSecForIosWeb: 4);
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "${Config.base_url}Midtrans/index.php?name=test&email=${widget.email}&phone=${widget.phonNumber}&amt=${widget.totalAmount}"));
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
