import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Api/Config.dart';

class Payfast extends StatefulWidget {
  final String totalAmount;
  const Payfast({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<Payfast> createState() => _PayfastState();
}

class _PayfastState extends State<Payfast> {

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
            if (uri.queryParameters["status"] == null) {
              accessToken = uri.queryParameters["token"];
            } else {
              if (uri.queryParameters["status"] == "success") {
                payerID = await uri.queryParameters["payment_id"];
                Get.back(result: payerID);
              } else {
                Get.back();
                Fluttertoast.showToast(msg: "${uri.queryParameters["status"]}",timeInSecForIosWeb: 4);
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "${Config.base_url}Payfast/index.php?amt=${widget.totalAmount}"));
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
