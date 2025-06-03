// ignore_for_file: file_names, avoid_print, sized_box_for_whitespace

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Controller/AppController.dart';
import 'package:goevent2/Controller/paystackcontroller.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/payment/InputFormater.dart';
import 'package:goevent2/payment/Khaltipayment.dart';
import 'package:goevent2/payment/PayPal.dart';
import 'package:goevent2/payment/Payment_card.dart';
import 'package:goevent2/payment/StripeWeb.dart';
import 'package:goevent2/payment/checkout.dart';
import 'package:goevent2/payment/midtrans.dart';
import 'package:goevent2/payment/payfast.dart';
import 'package:goevent2/payment/paypal_payment.dart';
import 'package:goevent2/payment/paystack.dart';
import 'package:goevent2/payment/senangpay.dart';
import 'package:goevent2/paypal/flutter_paypal.dart';
import 'package:goevent2/profile/Wallet/WalletHistory.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/ctextfield.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../payment/flutterwave.dart';
import '../../payment/mercadopogo.dart';
import '../../payment/paystackweb.dart';
import '../../payment/razorpay.dart';

class AddWalletPage extends StatefulWidget {
  final String? amount;
  const AddWalletPage({Key? key, this.amount}) : super(key: key);

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {

  RazorpayScreen razorpayScreen = RazorpayScreen();
  final pData = Get.put(HomeDataContro());

  final addAmount = TextEditingController();
  late ColorNotifire notifire;
  List walletitem = [];
  String? totalAmount = "0";
  int amount = 0;
  //! payment var
  String? selectidpay = "1";
  int _groupValue = 0;
  String? paymenttital;
  String ticketType = "";

  String typeid = "";
  String razorpaykey = "";
  String paystackID = "";

  PaystackController paystackController = Get.put(PaystackController());

  @override
  void initState() {

    razorpayScreen.initiateRazorpay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);
    pData.paymentgateway();
    getdarkmodepreviousstate();
    super.initState();
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    walletupdate();
  }
  void handlePaymentError(PaymentSuccessResponse response) {}
  void handleExternalWallet(PaymentSuccessResponse response) {}

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  walletupdate() async {
    var data = {"uid": uID, "wallet": addAmount.text};

    ApiWrapper.dataPost(Config.walletup,  data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletReportPage(),));
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    Get.back();
    // buyNoworder(response.paymentId);
    walletupdate();
    ApiWrapper.showToastMessage("Payment Successfully");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Error Response: ${"ERROR: " + response.code.toString() + " - " + response.message!}');
    ApiWrapper.showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ApiWrapper.showToastMessage(response.walletName!);
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,
        child: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (addAmount.text.isNotEmpty) {
              paymentSheet(context);
            } else {
              ApiWrapper.showToastMessage("please enter amount");
            }
          },
          child: Custombutton.button1(
              notifire.getbuttonscolor,
              "Add".tr.toUpperCase(),
              SizedBox(width: width / 3.5),
              SizedBox(width: width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          SizedBox(height: height / 20),
          //! ------- AppBar -------

          Row(
            children: [
              SizedBox(width: width / 40),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletReportPage(),));
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: notifire.textcolor),
                    SizedBox(width: width / 80),
                    Text(
                      "Add Wallet".tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.03),
            child: Container(
              height: Get.height * 0.20,
              width: Get.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('image/walletTop.png'),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: EdgeInsets.only(left: Get.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${mainData["currency"]}${widget.amount}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: notifire.getwhite),
                    ),
                    Text(
                      "Your current Balance ".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: notifire.getwhite),
                    ),
                    Container(height: Get.height * 0.04)
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Add Amount".tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy Bold',
                    color: notifire.textcolor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.02),
                Customtextfild.textField(
                  controller: addAmount,
                  name1: "Amount".tr,
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  keyboardType: TextInputType.number,
                  prefixIcon: InkWell(
                    child: Image.asset("image/wallet.png",
                        scale: 3.5, color: notifire.textcolor),
                    onTap: () {
                      setState(() {
                        amount = amount + 10;
                      });
                    },
                  ), context: context,
                ),
                SizedBox(height: Get.height * 0.03),
                Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    amountRow(
                      title: "100",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "100";
                      },
                    ),
                    amountRow(
                      title: "200",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "200";
                      },
                    ),
                    amountRow(
                      title: "300",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "300";
                      },
                    ),
                    amountRow(
                      title: "400",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "400";
                      },
                    ),
                    amountRow(
                      title: "500",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "500";
                      },
                    ),
                    amountRow(
                      title: "600",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "600";
                      },
                    ),
                    amountRow(
                      title: "700",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "700";
                      },
                    ),
                    amountRow(
                      title: "800",
                      onTap: () {
                        setState(() {});
                        addAmount.text = "800";
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  amountRow({Function()? onTap, String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: Get.height * 0.045,
          width: Get.width * 0.20,
          decoration: BoxDecoration(
              color: notifire.getcardcolor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: notifire.bordercolore, width: 1)),
          child: Center(
            child: Text(
              title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.textcolor),
            ),
          ),
        ),
      ),
    );
  }

  // !--------------- payment --------------------

  // Future paymentSheet() {
  //   return showModalBottomSheet(
  //     backgroundColor: notifire.getprimerycolor,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: Get.height * 0.6,
  //         child: StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 SizedBox(height: height / 40),
  //                 Center(
  //                   child: Container(
  //                     height: height / 80,
  //                     width: width / 5,
  //                     decoration: const BoxDecoration(
  //                         color: Colors.grey,
  //                         borderRadius:
  //                             BorderRadius.all(Radius.circular(20))),
  //                   ),
  //                 ),
  //                 SizedBox(height: height / 50),
  //                 Row(
  //                   children: [
  //                     SizedBox(width: width / 14),
  //                     Text("Select Payment Method".tr,
  //                         style: TextStyle(
  //                             color: notifire.getdarkscolor,
  //                             fontSize: height / 40,
  //                             fontFamily: 'Gilroy_Bold')),
  //                   ],
  //                 ),
  //                 SizedBox(height: height / 50),
  //                 //! --------- List view payment ----------
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: pData.paymentList.length,
  //                   scrollDirection: Axis.vertical,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemBuilder: (ctx, i) {
  //                     return Padding(
  //                       padding: const EdgeInsets.symmetric(vertical: 8),
  //                       child: sugestlocationtype(
  //                         borderColor:
  //                             selectidpay == pData.paymentList[i]["id"]
  //                                 ? buttonColor
  //                                 : const Color(0xffD6D6D6),
  //                         title: pData.paymentList[i]["title"],
  //                         titleColor: notifire.getdarkscolor,
  //                         val: 0,
  //                         image:
  //                             Config.base_url + pData.paymentList[i]["img"],
  //                         adress: pData.paymentList[i]["subtitle"],
  //                         ontap: () async {
  //                           setState(() {
  //                             razorpaykey =
  //                                 pData.paymentList[i]["attributes"];
  //                             paymenttital = pData.paymentList[i]["title"];
  //                             selectidpay = pData.paymentList[i]["id"];
  //                             _groupValue = i;
  //                           });
  //                         },
  //                         radio: Radio(
  //                           activeColor: buttonColor,
  //                           value: i,
  //                           groupValue: _groupValue,
  //                           onChanged: (value) {
  //                             setState(() {});
  //                             // _groupValue = i;
  //                           },
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //
  //                 SizedBox(height: Get.height * 0.02),
  //                 InkWell(
  //                     onTap: () {
  //                       //!---- Stripe Payment ------
  //
  //                       if (paymenttital == "Stripe") {
  //                         Get.back();
  //                         stripePayment();
  //                       } else if (paymenttital == "Paypal") {
  //                         //!---- PayPal Payment ------
  //                         Get.to(() =>
  //                                 PayPalPayment(totalAmount: addAmount.text))!
  //                             .then((otid) {
  //                           if (otid != null) {
  //                             walletupdate();
  //                             // buyNoworder(otid);
  //                             ApiWrapper.showToastMessage(
  //                                 "Payment Successfully");
  //                           } else {
  //                             Get.back();
  //                           }
  //                         });
  //                       } else if (paymenttital == "Razorpay") {
  //                         //!---- Razorpay Payment ------
  //                         Get.back();
  //                         openCheckout();
  //                       }
  //                     },
  //                     child: paynowbutton()),
  //                 SizedBox(height: Get.height * 0.04),
  //               ],
  //             ),
  //           );
  //         }),
  //       );
  //     },
  //   );
  // }


 Future paymentSheet(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            height: Get.height * 0.6,
            child:  StatefulBuilder(
                builder: (context, setState)  {
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                    child: Scaffold(
                      // backgroundColor: notifier.containercoloreproper,
                      // backgroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                      floatingActionButton: InkWell(
                          onTap: () {
                            //!---- Stripe Payment ------
                            print(("DSD:LSD:SLD:SLDS:DLS:DLS:DL"));
                            if (paymenttital == "Stripe") {
                              Get.back();
                              stripePayment();
                            } else if (paymenttital == "Paypal") {
                              //!---- PayPal Payment ------
                              List ids = pData.paymentList[_groupValue]["attributes"].toString().split(",");
                              paypalPayment(
                                  amt: addAmount.text,
                                  key: ids[0],
                                  secretKey: ids[1],
                                  function: (){
                                    walletupdate();
                                  },
                                context: context
                                );

                            } else if (paymenttital == "Razorpay") {
                              //!---- Razorpay Payment ------
                              Get.back();
                              razorpayScreen.getcheckout(
                                amount: addAmount.text,
                                contact: getData.read("UserLogin")["mobile"],
                                description: ticketType,
                                email: getData.read("UserLogin")["email"],
                                key: razorpaykey,
                                name: getData.read("UserLogin")["name"],
                              );
                            } else if (paymenttital == "FlutterWave") {
                              //!---- Flutterwave Payment ------!
                              print(("DSD:LSD:SLD:SLDS:DLS:DLS:DL"));
                              Get.to(() => Flutterwave(
                                  totalAmount: (double.parse(addAmount.text)).toString(),
                                  email: getData.read("UserLogin")["email"]
                              ))!
                                  .then((otid) {
                                if (otid != null) {
                                  // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                  Fluttertoast.showToast(msg: 'Payment Successfully', timeInSecForIosWeb: 4);
                                  walletupdate();
                                } else {
                                  Get.to(WalletReportPage());
                                }
                              });
                              // Get.back();
                            } else if (paymenttital == "MercadoPago") {
                              //!---- Flutterwave Payment ------!
                              Get.to(() => merpago(
                                totalAmount: (double.parse(addAmount.text)).toString(),
                              ))!
                                  .then((otid) {
                                if (otid != null) {
                                  // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                  Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                  walletupdate();
                                } else {
                                  Get.back();
                                }
                              });
                              // Get.back();
                            } else if(paymenttital == "PayStack"){

                              paystackController.paystack(addAmount.text.toString()).then((value) {
                                print("URLLLLL L L ${paystackController.paystackData!.data!.authorizationUrl}");
                                Get.to(() => Paystackweb(url: paystackController.paystackData!.data!.authorizationUrl, skID: paystackID,))!.then((otid) {
                                  if (otid != null) {
                                    Fluttertoast.showToast(msg: 'Payment Successfully', timeInSecForIosWeb: 4);
                                    walletupdate();
                                  } else {
                                    Get.to(WalletReportPage());
                                  }
                                });
                              },);

                            } else if(paymenttital == "SenangPay"){
                              Get.to(() => Senangpay(
                                phone: getData.read("UserLogin")["mobile"],
                                name: getData.read("UserLogin")["name"],
                                email: getData.read("UserLogin")["email"],
                                totalAmount: (double.parse(addAmount.text)).toString(),
                              ))!
                                  .then((otid) {
                                if (otid != null) {
                                  // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                  Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                  walletupdate();
                                } else {
                                  Get.to(WalletReportPage());
                                }
                              });
                            } else if(paymenttital == "Payfast"){
                              Get.to(() => Payfast(
                                totalAmount: (double.parse(addAmount.text)).toString(),
                              ))!
                                  .then((otid) {
                                if (otid != null) {
                                  // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                  Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                  walletupdate();
                                } else {
                                  Get.back();
                                }
                              });
                            } else if(paymenttital == "Midtrans"){
                              Get.to(() => Midtrans(
                                phonNumber: getData.read("UserLogin")["mobile"],
                                email: getData.read("UserLogin")["email"],
                                totalAmount: (double.parse(addAmount.text)).toString(),
                              ))!
                                  .then((otid) {
                                if (otid != null) {
                                  // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                  Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                  walletupdate();
                                } else {
                                  Get.to(WalletReportPage());
                                }
                              });
                            } else if(paymenttital == "2checkout"){
                              Get.to(() => Checkout(
                                totalAmount: (double.parse(addAmount.text)).toString(),
                              ))!
                                  .then((otid) {
                                if (otid != null) {
                                  // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                  Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                  walletupdate();
                                } else {
                                  Get.to(WalletReportPage());
                                }
                              });
                            } else if(paymenttital == "Khalti Payment"){
                              Get.to(() => Khaltipayment(
                                totalAmount: (double.parse(addAmount.text)).toString(),
                              ))!
                                  .then((otid) {
                                if (otid != null) {
                                  // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                  Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                  walletupdate();
                                } else {
                                  Get.to(WalletReportPage());
                                }
                              });
                            }
                          },
                          child: paynowbutton()),
                      body: Container(
                        height: 410,
                        decoration:   BoxDecoration(
                            color: notifire.backgrounde,
                            // color: Colors.yellowAccent,

                            // border: Border.all(color: notifier.textColor),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                        ),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget> [

                            const SizedBox(height: 13,),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("Select Payment Method".tr,
                                  style: TextStyle(
                                      color: notifire.textcolor,
                                      fontSize: height / 40,
                                      fontFamily: 'Gilroy_Bold')),
                            ),
                            const SizedBox(height: 4,),
                            Expanded(
                              child: ListView.separated(
                                // shrinkWrap: true,
                                // itemCount: pData.paymentList.length,
                                // scrollDirection: Axis.vertical,
                                // physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(width: 0,);
                                },
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemCount: pData.paymentList.length,
                                itemBuilder: (ctx, i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: sugestlocationtype(
                                      borderColor:
                                      selectidpay == pData.paymentList[i]["id"]
                                          ? buttonColor
                                          : const Color(0xffD6D6D6),
                                      title: pData.paymentList[i]["title"],
                                      titleColor: notifire.textcolor,
                                      val: 0,
                                      image:
                                      Config.base_url + pData.paymentList[i]["img"],
                                      adress: pData.paymentList[i]["subtitle"],
                                      ontap: () async {
                                        setState(() {
                                          paystackID = pData.paymentList[i]["attributes"].toString().split(",").last;

                                          razorpaykey = pData.paymentList[i]["attributes"];
                                          print("RAZORPAY > > > $razorpaykey");
                                          paymenttital = pData.paymentList[i]["title"];
                                          selectidpay = pData.paymentList[i]["id"];
                                          _groupValue = i;
                                        });
                                      },
                                      radio: Theme(
                                        data: ThemeData(unselectedWidgetColor: notifire.textcolor),
                                        child: Radio(
                                          activeColor: buttonColor,
                                          value: i,
                                          groupValue: _groupValue,
                                          onChanged: (value) {
                                            setState(() {});
                                            // _groupValue = i;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            )
        );
      },
      backgroundColor: notifire.backgrounde,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }

  // paypalPayment({
  //   required String amt,
  //   required String key,
  //   required String secretKey,
  //   var function,
  //   context}
  //     ) {
  //   print("----------->>" + key.toString());
  //   print("----------->>" + secretKey.toString());
  //   Get.back();
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return UsePaypal(
  //           sandboxMode: true,
  //           clientId: key,
  //           secretKey: secretKey,
  //           returnURL:
  //           "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-35S7886705514393E",
  //           cancelURL: "${Config.base_url}/paypal/cancle.php",
  //           transactions: [
  //             {
  //               "amount": {
  //                 "total": amt,
  //                 "currency": "USD",
  //                 "details": {
  //                   "subtotal": amt,
  //                   "shipping": '0',
  //                   "shipping_discount": 0
  //                 }
  //               },
  //               "description": "The payment transaction description.",
  //               "item_list": {
  //                 "items": [
  //                   {
  //                     "name": "A demo product",
  //                     "quantity": 1,
  //                     "price": amt,
  //                     "currency": "USD"
  //                   }
  //                 ],
  //               }
  //             }
  //           ],
  //           note: "Contact us for any questions on your order.",
  //           onSuccess: (Map params) {
  //             function(params);
  //             Fluttertoast.showToast(msg: 'SUCCESS PAYMENT : $params',timeInSecForIosWeb: 4);
  //           },
  //           onError: (error) {
  //             Fluttertoast.showToast(msg: error.toString(),timeInSecForIosWeb: 4);
  //           },
  //           onCancel: (params) {
  //             Fluttertoast.showToast(msg: params.toString(),timeInSecForIosWeb: 4);
  //           },
  //           // amount: amt,
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget paynowbutton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: height / 16,
        width: width / 1.1,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
              "PAY NOW | "
              "${mainData["currency"]}${addAmount.text}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy_Medium')),
        ),
      ),
    );
  }

  //!--------------------------- payment Widget --------------------
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final _card = PaymentCard();
  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Ink(
                child: Column(
                  children: [
                    SizedBox(height: height / 45),
                    Center(
                      child: Container(
                        height: height / 85,
                        width: width / 5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.03),
                          Text('Add Your payment information'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5)),
                          SizedBox(height: height * 0.02),
                          Form(
                              key: _formKey,
                              autovalidateMode: _autoValidateMode,
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                        CardNumberInputFormatter()
                                      ],
                                      controller: numberController,
                                      onSaved: (String? value) {
                                        _paymentCard.number =
                                            CardUtils.getCleanedNumber(value!);

                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(
                                                _paymentCard.number.toString());
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      onChanged: (val) {
                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(val);
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      validator: CardUtils.validateCardNum,
                                      decoration: InputDecoration(
                                          prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 6),
                                                  child: CardUtils.getCardIcon(
                                                      _paymentCard.type))),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          focusedBorder:
                                              OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                          hintText: 'What number is written on card?'.tr,
                                          labelStyle: TextStyle(color: buttonColor),
                                          labelText: 'Number'.tr)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                              prefixIcon: SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 14),
                                                      child: Image.asset(
                                                          'image/card_cvv.png',
                                                          width: 6,
                                                          color: buttonColor))),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor)),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: buttonColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(color: buttonColor)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                              hintText: 'Number behind the card'.tr,
                                              labelStyle: TextStyle(color: buttonColor),
                                              labelText: 'CVV'),
                                          validator: CardUtils.validateCVV,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            _paymentCard.cvv =
                                                int.parse(value!);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: Get.width * 0.03),
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            CardMonthInputFormatter()
                                          ],
                                          decoration: InputDecoration(
                                              prefixIcon: SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 14),
                                                      child: Image.asset(
                                                          'image/calender.png',
                                                          width: 10,
                                                          color: buttonColor))),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: buttonColor)),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(color: buttonColor)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                              hintText: 'MM/YY'.tr,
                                              labelStyle: TextStyle(color: buttonColor),
                                              labelText: 'Expiry Date'.tr),
                                          validator: CardUtils.validateDate,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            List<int> expiryDate =
                                                CardUtils.getExpiryDate(value!);
                                            _paymentCard.month = expiryDate[0];
                                            _paymentCard.year = expiryDate[1];
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: Get.height * 0.055),
                                  Container(
                                      alignment: Alignment.center,
                                      child: _getPayButton()),
                                  SizedBox(height: Get.height * 0.065),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      var username = getData.read("UserLogin")["name"].toString().split(" ").first ?? "";
      var lastname = getData.read("UserLogin")["name"].toString().split(" ").last ?? "";
      var email = getData.read("UserLogin")["email"] ?? "";
      _paymentCard.name = "$username$lastname";
      _paymentCard.email = email;
      _paymentCard.amount = addAmount.text;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        //! order Api call
        if (otid != null) {
          log(otid.toString(), name: "StripePaymentWeb irder id :: ");
          //! Api Call Payment Success
          walletupdate();
        }
      });

      _showInSnackBar('Payment card is valid');
    }
  }

  Widget _getPayButton() {
    return SizedBox(
      width: Get.width,
      child: CupertinoButton(
          onPressed: _validateInputs,
          color: buttonColor,
          child: Text("Pay ${mainData["currency"]}${addAmount.text}",
              style: const TextStyle(fontSize: 17.0, color: Colors.white))),
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value), duration: const Duration(seconds: 3)));
  }

  // void openCheckout() async {
  //   var username = getData.read("UserLogin")["name"] ?? "";
  //   var mobile = getData.read("UserLogin")["mobile"] ?? "";
  //   var email = getData.read("UserLogin")["email"] ?? "";
  //   var options = {
  //     'key': razorpaykey,
  //     'amount': (double.parse(addAmount.text) * 100).toString(),
  //     'name': username,
  //     'description': ticketType,
  //     'timeout': 300,
  //     'prefill': {'contact': mobile, 'email': email},
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  //
  //   initiateRazorpay({required Function handlePaymentSuccess, required Function handlePaymentError, required Function handleExternalWallet}){
  //     _razorpay = Razorpay();
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
  //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  //   }
  //
  //   desposRazorPay() {
  //     _razorpay.clear();
  //   }
  // }
}
