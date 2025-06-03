import 'dart:convert';

import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:http/http.dart' as http;

import '../Api/Config.dart';

class OtpController extends GetxController implements GetxService {

  Future smstype() async {

    var response = await http.get(Uri.parse(Config.api_url + Config.smstype),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var smsType = jsonDecode(response.body);
      update();
      print(" SMS CODE TYPE >>>>>>>>>>>>>> : : : : : :${smsType["SMS_TYPE"]}");
      return smsType;
    }
  }

  Future sendOtp({required String mobile}) async {

    Map body = {
      "mobile": mobile,
    };

    var response = await http.post(Uri.parse(Config.api_url + Config.msgotp),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );
    print("><<<<<<<<<<<<<<<<<<$body");

    if(response.statusCode == 200){
      var msgdecode = jsonDecode(response.body);

      if(msgdecode["Result"] == "true"){
        print(" OTP CODE : >>> ${msgdecode["otp"]}");
        update();
        return msgdecode;
      } else {
        ApiWrapper.showToastMessage(msgdecode["ResponseMsg"]);
      }
    } else {
      ApiWrapper.showToastMessage("Something went wrong!");
    }
  }

  Future twilloOtp({required String mobile}) async {

    Map body = {
      "mobile" : mobile
    };

    var response = await http.post(Uri.parse(Config.api_url + Config.twillotp),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );
    print("><<<<<<<<<<<<<<<<<<$body");

    if(response.statusCode == 200){
      var msgdecode = jsonDecode(response.body);

      if(msgdecode["Result"] == "true"){
        print(" OTP CODE : >>> ${msgdecode["otp"]}");
        update();
        return msgdecode;
      } else {
        ApiWrapper.showToastMessage('Invalid Mobile Number');
      }
    } else {
      ApiWrapper.showToastMessage("Something went wrong!");
    }
  }
}