// ignore_for_file: file_names, unused_local_variable, avoid_print

import 'dart:developer';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/Bottombar.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/login_signup/login.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:http/http.dart';
import '../agent_chat_screen/auth_service.dart';
import '../login_signup/verification.dart';

class AuthController extends GetxController {
  // UserData? userData;
  var countryCode = [];

  String? uID;

  //! user CountryCode
  cCodeApi() {
    ApiWrapper.dataGet(Config.cCode).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["CountryCode"].forEach((e) {
            countryCode.add(e['ccode']);
          });
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  //! user Login Api
  userLogin(String? number, password) {
    var data = {"username": number, "password": password};
    log(data.toString(), name: "Login Api : ");
    ApiWrapper.dataPost(Config.loginuser, data).then((val) {
      log(val.toString(), name: "Login Api : ");
      print("42 , AuthController.dart, val : ${val}");
      if ((val != null) && (val.isNotEmpty)) {
        if (val["metadata"]["statusCode"] == 200 && val["data"] != null) {
          save("FirstUser", true);
          save("UserLogin", val["data"]);
          print(val["UserLogin"]);
          //AuthService().singInAndStoreData(email: val["UserLogin"]["email"], uid: val["UserLogin"]["id"], proPicPath: val["UserLogin"]["pro_pic"] ?? "");
          AuthService().singInAndStoreData(email: "", uid: "", proPicPath: "");
          Get.to(() => const Bottombar(), duration: Duration.zero);
          update();
          //ApiWrapper.showToastMessage(val["ResponseMsg"]);
          ApiWrapper.showToastMessage(val["metadata"]["message"]);
        } else {
          //ApiWrapper.showToastMessage(val["ResponseMsg"]);
          ApiWrapper.showToastMessage(val["metadata"]["message"]);
        }
      }
    });
  }

  //! user Register Api
  userRegister() {
    var name = getData.read("User")["UserName"];
    var Lastname = getData.read("User")["UserLastName"];
    var password = getData.read("User")["FPassword"];
    var email = getData.read("User")["UserEmail"];
    var ccode = getData.read("User")["Ccode"];
    var mobile = getData.read("User")["Usernumber"];
    var rcode = getData.read("User")["ReferralCode"];
    var regMode = getData.read("User")["RegistrationMode"];
    var social = getData.read("User")["SocialOpenId"];
    var data = {
      "firstName": getData.read("User")["UserName"],
      "lastName": "",   //getData.read("User")["UserLastName"],
      "password": getData.read("User")["FPassword"],
      "email": getData.read("User")["UserEmail"],
      "phoneCountryCode": "", //getData.read("User")["Ccode"],
      "phoneNumber": "",    //getData.read("User")["Usernumber"],
      "registrationMode": "Eirle",
      "socialOpenId":""
    };

    ApiWrapper.dataPost(Config.reguser, data).then((val) {
      print('++++++++++++++++++++---------------*****+++$val');
      if ((val != null) && (val.isNotEmpty)) {
        log(val.toString(), name: "Api Register data::");
        print("87 , AuthController.dart --- val : ${val}");
        print("88 , AuthController.dart --- val : ${val['metadata']['statusCode']}");
        print("88 , AuthController.dart --- val : ${val['metadata']['Email OTP']}");
        if ((val['metadata']['statusCode'] == "200" || val['metadata']['statusCode'] == 200)) {
          //save("UserLogin", val["UserLogin"]);
          //AuthService().singUpAndStore(email: val["UserLogin"]["email"], uid: val["UserLogin"]["id"], proPicPath: val["UserLogin"]["pro_pic"]);
          //Get.to(() => const Bottombar(), duration: Duration.zero);
          // if(val['metadata']['Email OTP'] == null){
          //   ApiWrapper.showToastMessage("This email is already exist");
          // }else{

          //-------------otp verification
            Get.to(() => Verification(
                otp: val['metadata']['Email OTP'],
                email: getData.read("User")["UserEmail"],
            ),
              duration: Duration.zero);
          // }

          //Get.to(() => const Login(), duration: Duration.zero);
          //ApiWrapper.showToastMessage(val["ResponseMsg"]);
          //ApiWrapper.showToastMessage('Registration done');
          update();
        } else{
          //ApiWrapper.showToastMessage(val["ResponseMsg"]);
          ApiWrapper.showToastMessage(val['metadata']['message']);
        }
      }
    });
  }

  VerifyEmail(email, otp) {
    var data = {
      "email": email,
      "otp": otp
    };
    print('125 +++ AuthController.dart -*****+++ data : ${data}');
    ApiWrapper.dataPost(Config.confirmEmailFT, data).then((val) {
      print('127 +++ AuthController.dart -*****+++ val : $val');
      if ((val != null) && (val.isNotEmpty)) {
        log(val.toString(), name: "Api Register data::");
        print("87 , AuthController.dart --- val : ${val}");
        print("88 , AuthController.dart --- val : ${val['metadata']['statusCode']}");
        print("88 , AuthController.dart --- val : ${val['metadata']['Email OTP']}");
        if ((val['metadata']['statusCode'] == "200" || val['metadata']['statusCode'] == 200)) {
          //save("UserLogin", val["UserLogin"]);
          ApiWrapper.showToastMessage(val['metadata']['message']);
          Get.to(() => const Login(), duration: Duration.zero);
          // }

          //Get.to(() => const Login(), duration: Duration.zero);
          //ApiWrapper.showToastMessage(val["ResponseMsg"]);
          //ApiWrapper.showToastMessage('Registration done');
          update();
        } else{
          //ApiWrapper.showToastMessage(val["ResponseMsg"]);
          ApiWrapper.showToastMessage(val['metadata']['message']);
        }
      }
    });
  }

}