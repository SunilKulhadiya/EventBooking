import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayScreen {

  Razorpay _razorpay = Razorpay();

  getcheckout({required String key, required String amount, required String name, required String description, required String contact, required String email}) {

    print("<><><><><><><><>>${amount}>");
    var options = {
      'key': key,
      'amount': double.parse(amount.toString()) * 100,
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email
      }
    };

    try{
      _razorpay.open(options);
    } catch (e){
      print('Error $e');
    }
  }

  initiateRazorpay({required Function handlePaymentSuccess, required Function handlePaymentError, required Function handleExternalWallet}){
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  desposRazorPay() {
    _razorpay.clear();
  }
}