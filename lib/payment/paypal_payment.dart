// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_string_interpolations, avoid_print, file_names

import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:goevent2/paypal/flutter_paypal.dart';

import '../Api/Config.dart';

paypalPayment({
  required String amt,
  required String key,
  required String secretKey,
  var function,
  context}
    ) {
  print("----------->>" + key.toString());
  print("----------->>" + secretKey.toString());
  Get.back();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return UsePaypalScreen(
          sandboxMode: true,
          clientId: key,
          secretKey: secretKey,
          returnURL:
          "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-35S7886705514393E",
          cancelURL: "${Config.api_url}paypal/cancle.php",
          transactions: [
            {
              "amount": {
                "total": amt,
                "currency": "USD",
                "details": {
                  "subtotal": amt,
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              "item_list": {
                "items": [
                  {
                    "name": "A demo product",
                    "quantity": 1,
                    "price": amt,
                    "currency": "USD"
                  }
                ],
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) {
            function();
            Fluttertoast.showToast(msg: 'SUCCESS PAYMENT',timeInSecForIosWeb: 4);
          },
          onError: (error) {
            Fluttertoast.showToast(msg: error.toString(),timeInSecForIosWeb: 4);
          },
          onCancel: (params) {
            Fluttertoast.showToast(msg: params.toString(),timeInSecForIosWeb: 4);
          },
        );
      },
    ),
  );
}


