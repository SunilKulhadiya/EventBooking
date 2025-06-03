// ignore_for_file: unused_local_variable, prefer_final_fields, avoid_function_literals_in_foreach_calls, unused_field, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/login_signup/resetpass.dart';
import 'package:goevent2/login_signup/signup.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/ctextfield.dart';
import 'package:goevent2/utils/itextfield.dart';
import 'package:goevent2/utils/media.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userverification extends StatefulWidget {
  const Userverification({Key? key}) : super(key: key);

  @override
  _UserverificationState createState() => _UserverificationState();
}

class _UserverificationState extends State<Userverification> {
  final login = Get.put(AuthController());

  late ColorNotifire notifire;
  bool status = false;
  final number = TextEditingController();
  final password = TextEditingController();
  List<String> _countryCodes = [];
  String? dropdownValue = "";
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    dropdownValue = login.countryCode.first;

    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                SizedBox(height: height / 11),
                Center(
                    child:
                    Image.asset("image/logo3.png", height: height / 13)),
                SizedBox(height: height / 100),
                Text(
                  "Cityrise".tr,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy Medium',
                      color: notifire.gettextcolor),
                ),
                SizedBox(height: height / 30),
                Row(
                  children: [
                    Text(
                      "Verify OTP".tr,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getwhitecolor),
                    ),
                  ],
                ),
                SizedBox(height: height / 40),
                Ink(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 45,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: notifire.bordercolore)),
                          child: Icon(Icons.account_circle_outlined, size: 30,)

                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     const SizedBox(width: 10),
                        //     Image.asset("image/Call1.png", scale: 3.5,color: notifire.textcolor),
                        //     cpicker(),
                        //   ],
                        // ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Customtextfild.textField(
                          controller: number,
                          //name1: "Mobile number".tr,
                          name1: "Email id".tr,
                          //keyboardType: TextInputType.number,
                          labelclr: Colors.grey,
                          textcolor: notifire.getwhitecolor, context: context,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.2 ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (number.text.isNotEmpty && password.text.isNotEmpty) {
                      login.userLogin(number.text, password.text);
                    } else {
                      ApiWrapper.showToastMessage(
                          "Please fill required field!");
                    }
                  },
                  child: SizedBox(
                    height: 45,
                    child: Custombutton.button1(
                      notifire.getbuttonscolor,
                      "Next".tr,
                      SizedBox(width: width / 4),
                      SizedBox(width: width / 7),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?".tr,
                        style: TextStyle(
                            color: notifire.getwhitecolor,
                            fontSize: 12,
                            fontFamily: 'Gilroy Medium')),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const Signup(), duration: Duration.zero);
                      },
                      child: Text(
                        "Sign up".tr,
                        style: const TextStyle(
                          color: Color(0xff5669FF),
                          fontFamily: 'Gilroy Medium',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget log(clr, name, img, clr2) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.to(() => const Home(), duration: Duration.zero);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: clr),
          height: height / 15,
          width: width / 1.5,
          child: Row(
            children: [
              SizedBox(width: width / 10),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Image.asset(img)),
              SizedBox(width: width / 20),
              Text(
                name,
                style: TextStyle(
                    color: clr2,
                    fontFamily: 'Gilroy Medium',
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cpicker() {
    var countryDropDown = Ink(
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: notifire.getprimerycolor,
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                value: dropdownValue,
                items: login.countryCode.map((value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString(),
                          style: TextStyle(
                              fontSize: 14.0, color: notifire.getwhitecolor)));
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
      ),
    );
    return countryDropDown;
  }
}
