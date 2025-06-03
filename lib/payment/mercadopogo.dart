import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Api/ApiWrapper.dart';
import '../Api/Config.dart';


class merpago extends StatefulWidget {
  final String? totalAmount;

  const merpago({this.totalAmount});

  @override
  State<merpago> createState() => _merpagoState();
}

class _merpagoState extends State<merpago> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? accessToken;
  bool isLoading = true;

  String? payerID;
  var progress;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (navigation) async {
            final uri = Uri.parse(navigation.url);
            if (uri.queryParameters["status"] == null) {
              accessToken = uri.queryParameters["token"];
            } else {
              if (uri.queryParameters["status"] == "Completed") {
                payerID = uri.queryParameters["transaction_id"];
                Get.back(result: payerID);
              }else{

                Get.back();

                Fluttertoast.showToast(msg: "${uri.queryParameters["status"]}",timeInSecForIosWeb: 4);
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "${Config.base_url + "/merpago/index.php?amt=${widget.totalAmount}"}"));
  }

  late final WebViewController controller;

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