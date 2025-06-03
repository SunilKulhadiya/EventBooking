// ignore_for_file: file_names, constant_identifier_names

class Config {
  static const String oneSignel = '*********************';

  static const String base_url = 'https://goevent.zozostudio.tech/';
  static const String test_base_url = 'https://api-test.eirle.com';

  static const String api_url = base_url + '/eapi/';
  static const String test_api_url = test_base_url + '/api/';

  static const String userImage = base_url + "/images/profile/pic.png";

  static String firebaseKey = "";
  static const String notificationUrl = "https://fcm.googleapis.com/fcm/send";

  static const String paystackpayment = 'paystack/index.php';
  //static const String reguser = 'e_reg_user.php';
  static const String reguser = 'users/register';
  static const String confirmEmailFT = 'users/confirm-email';
  static const String smstype = 'sms_type.php';
  static const String msgotp = 'msg_otp.php';
  static const String twillotp = 'twilio_otp.php';
  static const String mobilecheck = 'e_mobile_check.php';
  static const String pagelist = 'e_pagelist.php';
  static const String cCode = 'e_country_code.php';
  //static const String loginuser = 'e_login_user.php';
  static const String loginuser = 'users/login';
  static const String forgetpassword = 'e_forget_password.php';
  static const String deleteAc = 'e_acc_delete.php';

  static const String homecategories = "event-categories";
  static const String homeSections = "Home/layout";

  static const String homedat = "e_home_data.php";
  static const String couponlist = 'e_couponlist.php';
  static const String paymentgateway = 'e_paymentgateway.php';
  static const String checkcoupon = 'e_check_coupon.php';
  static const String profileedit = 'pro_image.php';
  static const String profil = 'e_profile_edit.php';

  static const String faq = 'e_faq.php';
  static const String walletreport = 'e_wallet_report.php';
  static const String walletup = 'e_wallet_up.php';
  static const String egetdata = 'e_getdata.php';
  static const String eventdataApi = "e_event_data.php";
  static const String ebookmark = "e_bookmark.php";
  static const String bookmarkApi = "e_bookmark_list.php";
  static const String typePrice = "e_get_type_price.php";
  static const String ebookticket = "e_book_ticket.php";
  static const String ticketpreview = "e_ticket_preview.php";
  static const String eventSearch = "e_event_search.php";
  static const String catEvent = "e_cat_event.php";
  static const String bookticket = "e_book_ticket_data.php";
  static const String ticketCancel = "e_ticket_cancle.php";
  static const String ticketStatus = "e_ticket_status_wise.php";
  static const String ticketdata = "e_ticket_data.php";
  static const String refardata = "e_getdata.php";
  static const String rateUpdate = "e_rate_update.php";
  static const String notification = "e_notification_list.php";
}
