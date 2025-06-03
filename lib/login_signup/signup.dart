// ignore_for_file: prefer_final_fields, body_might_complete_normally_nullable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, deprecated_member_use, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/Controller/msgtype_controller.dart';
import 'package:goevent2/login_signup/login.dart';
import 'package:goevent2/login_signup/verification.dart';
import 'package:goevent2/profile/loream.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/AuthController.dart';
import '../home/home.dart';
import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/ctextfield.dart';
import '../utils/itextfield.dart';
import '../utils/media.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //bool status = false;
  bool status = true;
  final auth = FirebaseAuth.instance;
  late ColorNotifire notifire;
  final name = TextEditingController();
  final Lastname = TextEditingController();
  final number = TextEditingController();
  final email = TextEditingController();
  final fpassword = TextEditingController();
  final spassword = TextEditingController();
  final referral = TextEditingController();
  bool isLoading = false;
  String? _selectedCountryCode = '';
  final login = Get.put(AuthController());
  OtpController otpCont = Get.put(OtpController());

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
  bool obscureText_ = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void toggle() {
    setState(() {
      obscureText_ = !obscureText_;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = login.countryCode.first;
    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: height / 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: notifire.getwhitecolor),
                  ),
                ],
              ),
              SizedBox(height: height / 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Stack(
                          children: [
                            Column(
                                children: [
                                  SizedBox(height: height / 20),
                                  Center(
                                      child:
                                      Image.asset("image/logo3.png", height: height / 13)),
                                  SizedBox(height: height / 20),

                                  Row(
                                    children: [
                                      Text("Register".tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Gilroy Medium', color: notifire.getwhitecolor),),
                                    ],
                                  ),
                                  SizedBox(height: height / 40),
                                  Customtextfild.textField(controller: name, name1: "Enter your full name".tr, labelclr: Colors.grey, textcolor: notifire.getwhitecolor, prefixIcon: Image.asset("image/UserIcon.png", scale: 0.9,), context: context,),
                                  SizedBox(height: height / 40),
                                  // Customtextfild.textField(controller: Lastname, name1: "Last Name".tr, labelclr: Colors.grey, textcolor: notifire.getwhitecolor, prefixIcon: Image.asset("image/Profile.png", scale: 3.5,color: notifire.textcolor), context: context,),
                                  // SizedBox(height: height / 40),
                                  Customtextfild.textField(
                                    controller: email,
                                    name1: "Email".tr,
                                    labelclr: Colors.grey,
                                    textcolor: notifire.getwhitecolor,
                                    prefixIcon: Image.asset("image/Mailicon.png",
                                        scale: 0.9,
                                        //color: notifire.textcolor
                                    ),
                                    context: context,
                                  ),
                                  SizedBox(height: height / 40),
                                  // Ink(
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Container(
                                  //         height: 45,
                                  //         decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(10),
                                  //             border: Border.all(
                                  //                 width: 1,
                                  //                 color: notifire.bordercolore)),
                                  //         child: Row(
                                  //           mainAxisSize: MainAxisSize.min,
                                  //           children: [
                                  //             const SizedBox(width: 12),
                                  //             Image.asset("image/Call1.png", scale: 3.5,color: notifire.textcolor),
                                  //             cpicker(),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       const SizedBox(width: 8,),
                                  //       Expanded(
                                  //         child: Customtextfild.textField(
                                  //           controller: number,
                                  //           name1: "Mobile number".tr,
                                  //           keyboardType: TextInputType.number,
                                  //           labelclr: Colors.grey,
                                  //           textcolor: notifire.getwhitecolor, context: context,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(height: height / 40),
                                  Customtextfild2.textField(
                                    fpassword,
                                    _obscureText,
                                    "Your password".tr,
                                    Colors.grey,
                                    notifire.getwhitecolor,
                                    "image/LockIcon.png",
                                    GestureDetector(
                                        onTap: () {
                                          _toggle();
                                        },
                                        child: _obscureText
                                            ? Image.asset("image/Hide.png",
                                                scale: 3.5,color: notifire.textcolor,)
                                            : Image.asset("image/Show.png",
                                                scale: 3.5,color: notifire.textcolor)), context: context,
                                  ),
                                  SizedBox(height: height / 40),
                                  // Customtextfild2.textField(
                                  //   spassword,
                                  //   obscureText_,
                                  //   "Confirm password".tr,
                                  //   Colors.grey,
                                  //   notifire.getwhitecolor,
                                  //   "image/Lock.png",
                                  //   GestureDetector(
                                  //       onTap: () {
                                  //         toggle();
                                  //       },
                                  //       child: obscureText_
                                  //           ? Image.asset("image/Hide.png",
                                  //               height: 22,color: notifire.textcolor)
                                  //           : Image.asset("image/Show.png",
                                  //               height: 22,color: notifire.textcolor)), context: context,
                                  // ),
                                  // SizedBox(height: height / 40),
                                  // Customtextfild.textField(
                                  //   controller: referral,
                                  //   name1: "Referral code".tr,
                                  //   labelclr: Colors.grey,
                                  //   textcolor: notifire.getwhitecolor,
                                  //   keyboardType: TextInputType.number,
                                  //   prefixIcon: Image.asset("image/Discount-1.png", scale: 3.5,color: notifire.textcolor), context: context,
                                  // ),
                                  // SizedBox(height: Get.height * 0.02),
                                  // Row(
                                  //   children: [
                                  //     Ink(
                                  //       width: Get.width * 0.12,
                                  //       child: Transform.scale(
                                  //         scale: 0.7,
                                  //         child: CupertinoSwitch(
                                  //           activeColor: notifire.getbuttonscolor,
                                  //           value: status,
                                  //           onChanged: (value) {
                                  //             setState(() {});
                                  //             status = value;
                                  //           },
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(width: Get.width * 0.015),
                                  //     Center(
                                  //       child: RichText(
                                  //         text: TextSpan(
                                  //             text: "By continuing, ".tr,
                                  //             style: TextStyle(
                                  //                 color: notifire.getwhitecolor,
                                  //                 fontSize: 12),
                                  //             children: <TextSpan>[
                                  //               TextSpan(text: "You agree to GoEvent's \n".tr),
                                  //               TextSpan(
                                  //                   text: 'Terms of Use '.tr,
                                  //                   style: const TextStyle(
                                  //                       decoration: TextDecoration
                                  //                           .underline,
                                  //                       decorationThickness: 2.5),
                                  //                   recognizer:
                                  //                       TapGestureRecognizer()
                                  //                         ..onTap = () {
                                  //                           Get.to(() => Loream("Terms & Conditions".tr));
                                  //                         }),
                                  //               const TextSpan(text: "and "),
                                  //               TextSpan(
                                  //                   text: 'Privacy Policy.'.tr,
                                  //                   style: const TextStyle(
                                  //                       decoration: TextDecoration
                                  //                           .underline,
                                  //                       decorationThickness: 2.5),
                                  //                   recognizer:
                                  //                       TapGestureRecognizer()
                                  //                         ..onTap = () {
                                  //                           Get.to(() => Loream("Terms & Conditions".tr));
                                  //                         }),
                                  //             ]),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  SizedBox(height: Get.height * 0.10),
                                  GestureDetector(
                                    onTap: () {

                                      authSignUp();
                                      setState(() {
                                        isLoading = true;
                                      });
                                      // print('hahahaha');
                                    },
                                    child: SizedBox(
                                      height: 45,
                                      child: Custombutton.button1(
                                        notifire.getbuttonscolor,
                                        "Register".tr,
                                        SizedBox(width: width / 4),
                                        SizedBox(width: width / 5),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.height / 60),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account? ".tr,
                                        style: TextStyle(
                                            color: notifire.getwhitecolor,
                                            fontSize: 14,
                                            fontFamily: 'Gilroy Medium'),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => const Login(),
                                              duration: Duration.zero);
                                        },
                                        child: Text(
                                          "Sign in".tr,
                                          style: const TextStyle(
                                              color: Color(0xff5669FF),
                                              fontFamily: 'Gilroy Medium'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            isLoading
                                ? Column(
                              children: [
                                isLoadingCircular(),
                              ],
                            ) : Container(color: Colors.transparent,),
                          ],
                        ),
                  ),
                ),
              )
            ],
          )),
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
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
              value: _selectedCountryCode,
              items: login.countryCode.map((value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14.0, color: Colors.grey)));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCountryCode = value;
                });
              },
              style: Theme.of(context).textTheme.titleLarge),
        ),
      ),
    );
    return countryDropDown;
  }

  //

  authSignUp() {
    print('uhuhuhuhu');
    FocusScope.of(context).requestFocus(FocusNode());

    var mcheck = {"mobile": number.text};

    if (name.text.isNotEmpty &&
            email.text.isNotEmpty &&
            //number.text.isNotEmpty &&
            fpassword.text.isNotEmpty
        //&& spassword.text.isNotEmpty
        // &&        referral.text.isNotEmpty
        ) {

      if ((RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
          .hasMatch(email.text))) {
        if (fpassword.text.isNotEmpty) {
          //if (fpassword.text == spassword.text) {
          if (status == true) {
            var register = {
              "UserName": name.text.trim(),
              "UserLastName": name.text.trim(),
              "FPassword": fpassword.text.trim(),
              "SPassword": spassword.text.trim(),
              "UserEmail": email.text.trim(),
              "Ccode": _selectedCountryCode,
              "Usernumber": number.text.trim(),
              "RegistrationMode": "Eirle",
              "SocialOpenId":""
            };
            save("User", register);
            login.userRegister();
          } else {
            setState(() {
              isLoading = false;
            });
            ApiWrapper.showToastMessage("Accept terms & Condition is required");
          }
        } else {
          setState(() {
            isLoading = false;
          });
          ApiWrapper.showToastMessage("password not match");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ApiWrapper.showToastMessage('Please enter valid email address');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ApiWrapper.showToastMessage("Please fill required field!");
    }
  }

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        ApiWrapper.showToastMessage("Auth Completed!");
        setState(() {
          isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ApiWrapper.showToastMessage("Auth Failed!");
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        ApiWrapper.showToastMessage("OTP Sent!");
        setState(() {
          isLoading = false;
        });

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ApiWrapper.showToastMessage("Timeout!");
        setState(() {
          isLoading = false;
        });
      },
    );
  }
  Future popup(){
    return showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(color: notifire.getbuttonscolor,),
      );
    },
    );
  }
}
//15900 + 5700 = 21600


