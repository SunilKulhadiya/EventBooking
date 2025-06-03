// ignore_for_file: file_names, avoid_print, dead_code, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/utils/color.dart';
import 'package:http/http.dart' as http;

// Map map = {"uid": uID};

//! Api Call
class ApiWrapper {
  static var headers = {
    'Content-Type': 'application/json',
    'x-api-key': 'myapikey'
  };

  static var TestHeaders = {
    'Content-Type': 'application/json',
    'x-api-key': 'myapikey'
  };

  static doImageUpload(
      String endpoint, Map<String, String> params, List imgs) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(Config.api_url + endpoint));
    request.fields.addAll(params);
    for (int i = 0; i < imgs.length; i++) {
      log(imgs[i].toString(), name: "Image name $i");
      request.files.add(await http.MultipartFile.fromPath('image$i', imgs[i]));
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var model = await response.stream.bytesToString();

    return jsonDecode(model);
  }

  Future popup(){
    return Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        child: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: Text(
                    'Please don`t press back until the transaction is complete',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5),
                  ),
                ),
              ],
            );
          }
        ),
      ),
      barrierDismissible: false,
    );
  }

  static showToastMessage(message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: buttonColor.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 14.0);
  }

  // static dataPost(appUrl, method) async {
  //   print('fbghsjyhgfvjshgfbjshf:------------${method} , $appUrl');
  //   var url, UseHeader;
  //   try {
  //     if (appUrl == 'login') {
  //       url = Uri.parse(Config.test_api_url + "users/" + appUrl);
  //       UseHeader = TestHeaders;
  //     } else {
  //       url = Uri.parse(Config.api_url + appUrl);
  //       UseHeader = headers;
  //     }
  //     print("94 , ApiWrapper.dart, url : $url");
  //
  //     var request = await http.post(url, headers: UseHeader, body: jsonEncode(method));
  //     print("97 , response----- ${request}");
  //     print("98 , response----- ${request.body}");
  //
  //     var response = jsonDecode(request.body); // could throw FormatException
  //     print("100 , ApiWrapper.dart, request : ${response["metadata"]["statusCode"]}");
  //
  //     //if (response.statusCode == 200) {
  //     if (response["metadata"]["statusCode"] == 200) {
  //       print("111 , ApiWrapper.dart, response : $response");
  //       return response;
  //     } else {
  //       print("114 , ApiWrapper.dart, response : $response");
  //       return response;
  //     }
  //   } catch (e) {
  //     print("109, Exception----- $e");
  //
  //     return {
  //       "error": true,
  //       "ResponseMsg": e.toString(),
  //     };
  //   }
  // }

  static dataPost(appUrl, method) async {
    print('fbghsjyhgfvjshgfbjshf:------------${method}');
    if(appUrl == 'login'){
      try {
        var url = Uri.parse(Config.test_api_url + appUrl);
        print("133 , ApiWrapper.dart , url : ${url}");

        var request = await http.post(
            url, headers: headers, body: jsonEncode(method));

        print("138 ApiWrapper.dart , response : ${request.body}");

        var response = jsonDecode(request.body);
        print("response----- ${request.body}");

        if (request.statusCode == 200) {
          return response;
        } else {
          return response;
        }
      } catch (e) {
        return e;
        print("Exeption----- $e");
      }

    }else {
      try {
        var url = Uri.parse(Config.test_api_url + appUrl);
        print(url);

        var request = await http.post(
            url, headers: headers, body: jsonEncode(method));
        var response = jsonDecode(request.body);
        print("response----- ${request.body}");

        if (request.statusCode == 200) {
          return response;
        } else {
          return response;
        }
      } catch (e) {
        return e;
        print("Exeption----- $e");
      }
    }
  }

  static finalticketdataPost(appUrl, method) async {
    try {
      var url = Uri.parse(Config.api_url + appUrl);
      print(url);
      var request =
          await http.post(url, headers: headers, body: jsonEncode(method));

      if (request.statusCode == 200) {
        print("response----- ${request.body}");
        return request.body;
      } else {
        return request.body;
      }
    } catch (e) {
      return e;
      print("Exeption----- $e");
    }
  }

  static dataPostjsonEncode(appUrl, method) async {
    try {
      var url = Uri.parse(Config.api_url + appUrl);
      print(url);
      var request =
          await http.post(url, headers: headers, body: jsonEncode(method));

      if (request.statusCode == 200) {
        return request.body;
      } else {
        return request.body;
      }
    } catch (e) {
      return e;
      print("Exeption----- $e");
    }
  }

  static dataGet(appUrl) async {
    print("213 ApiWrapper.dart , appUrl : ${appUrl}");
    if(appUrl == "event-categories") {
      var token = getData.read("UserLogin")["accessToken"];
      print("215 ApiWrapper.dart , token : ${token}");
      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-api-key': 'myapikey'
      };

      var url = Uri.parse(Config.test_api_url + appUrl);
      var request = await http.get(url, headers: header);
      var response = jsonDecode(request.body);
      print("225 , ApiWrapper.dart , response : ${response}");
      if (request.statusCode == 200) {
        return response;
      } else {
        print(request.reasonPhrase);
      }
    }else{
      var url = Uri.parse(Config.api_url + appUrl);
      var request = await http.get(url, headers: headers);
      var response = jsonDecode(request.body);
      if (request.statusCode == 200) {
        return response;
      } else {
        print(request.reasonPhrase);
      }

    }
    // } catch (e) {
    //   return e;
    //
    //   print("Exeption----- $e");
    // }
  }

  static getHomeSections(appUrl) async {
    print("251 ApiWrapper.dart , appUrl : ${Config.test_api_url + appUrl}");
      var token = getData.read("UserLogin")["accessToken"];
      print("253 ApiWrapper.dart , token : ${token}");
      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-api-key': 'myapikey'
      };

      var url = Uri.parse(Config.test_api_url + appUrl);
      var request = await http.get(url, headers: header);
      var response = jsonDecode(request.body);
      print("263 , ApiWrapper.dart , response : ${response}");
      if (request.statusCode == 200) {
        return response;
      } else {
        print(request.reasonPhrase);
      }
  }

  static getHomeSectionSubData(appUrl) async {
    print("251 ApiWrapper.dart , appUrl : ${appUrl}");
    var token = getData.read("UserLogin")["accessToken"];
    print("253 ApiWrapper.dart , token : ${token}");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': 'myapikey'
    };

    var url = Uri.parse(appUrl);
    var request = await http.get(url, headers: header);
    var response = jsonDecode(request.body);
    print("263 , ApiWrapper.dart , response : ${response}");
    if (request.statusCode == 200) {
      return response;
    } else {
      print(request.reasonPhrase);
    }
  }

  static dataGetLocation(appUrl) async {
    try {
      var request = await http.get(appUrl, headers: headers);
      var response = jsonDecode(request.body);
      if (request.statusCode == 200) {
        return response;
      } else {
        print(request.reasonPhrase);
      }
    } catch (e) {
      print("Exeption----- $e");
    }
  }
}
