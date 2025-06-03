// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print, unused_local_variable, unused_import, unnecessary_null_comparison, prefer_final_fields, prefer_const_constructors

import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:goevent2/agent_chat_screen/firebaseaccess_token.dart';

import '../AppModel/Homedata/HomeModelSubData.dart';
import '../Search/searchpage2.dart';
import '../utils/media.dart';
import 'package:get/get.dart';

import '../utils/colornotifire.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:goevent2/Api/Config.dart';
import 'package:provider/provider.dart';

import 'package:goevent2/home/seeall.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/color.dart';
import '../notification/notification.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goevent2/utils/string.dart';
import 'package:like_button/like_button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/Search/SearchPage.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/home/TrendingCatPage.dart';

import 'package:goevent2/Controller/AuthController.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';

final getData = GetStorage();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final x = Get.put(AuthController());
  final hData = Get.put(HomeController());
  late ColorNotifire notifire;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  bool isChecked = false;
  String code = "0";

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");

    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  void initState() {
    super.initState();
    walletrefar();
    getdarkmodepreviousstate();
    getUserLocation().then((value) {
      getData.read("UserLogin") != null
          ? hData.homeDataApi(getData.read("UserLogin")["id"], lat, long)
          : null;
      getData.read("UserLogin") != null
          ? hData.HomeSections(getData.read("UserLogin")["id"], lat, long)
          : null;
    },);
    getPackage();
    print("LAT : $lat, LONG : $long");
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    OneSignal.initialize(Config.oneSignel);

    OneSignal.Notifications.addPermissionObserver((changes) {
      print("Accepted OSPermissionStateChanges : $changes");
    });

    FirebaseAccesstoken accesstoken = FirebaseAccesstoken();

    accesstoken.getAccessToken();

    print("--------------__uID : ${getData.read("UserLogin")["id"]}");
    await OneSignal.User.addTagWithKey("storeid", getData.read("UserLogin")["id"]);
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

 Future getUserLocation() async {
    Position position = await getLatLong();
    print("POSITION $position");
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      print("LAT : $lat, LONG : $long");
    });
  }

  Future<Position> getLatLong() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //! ----- LikeButtonTapped -----
  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          hData.homeDataReffressApi(getData.read("UserLogin")["id"], lat, long);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        backgroundColor: notifire.backgrounde,
        body: Column(
          children: [
            //! ------ Home AppBar ------
            homeAppbar(),
            Expanded(
                child: SingleChildScrollView(
                  child: !hData.isLoading && !hData.isLoadingHomeSections
                    ? Column(
                        children: [
                          SizedBox(height: height / 60),
                          //! ----- trending Event List ------ Categories all
                          SizedBox(height: height / 80),
                          hData.catlist.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: SizedBox(
                                    height: Get.height * 0.15,
                                    child: ListView.builder(
                                      itemCount: hData.catlist.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, i) {
                                        var catlist = hData.catlist;
                                        return treding(catlist, i);
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(height: hData.catlist.isNotEmpty ? Get.height * 0.03 : 0),
                          //! -----------------------Event List ------
                          hData.isLoadingHomeSections ? SizedBox.shrink() :
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: hData.homeSectionsData.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                      child: Text(
                                        hData.homeSectionsData[i].displayName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    hData.homeSectionsData[i].homemodelsubdata.length > 0 ?
                                    SizedBox(
                                      height: 200, // or any height you need
                                      child: GridView.builder(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: hData.homeSectionsData[i].homemodelsubdata.length,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 0.8,
                                        ),
                                        itemBuilder: (ctx, j) {
                                          return EventView(hData.homeSectionsData[i].homemodelsubdata[j]);
                                        },
                                      ),
                                    ): SizedBox.shrink(),
                                    const SizedBox(height: 20),
                                  ],
                                );
                            },
                          ),
                        ],
                      )
                    : isLoadingCircular(),
            )
            )
          ],
        ));
  }

  EventView(Homemodelsubdata eventview) {
    print("516 , home.dart , notifire.getprimerycolor : ${notifire.getprimerycolor}");
    return InkWell(
      onTap: () {
        //Get.to(() => TrndingPage(catdata: catList[i]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
              color: notifire.grey1,
              border: Border.all(color: notifire.bordercolore, width: 0.5),
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    image:
                    NetworkImage(eventview.iconUrl),
                    height: 60
                ),
                SizedBox(width: Get.width * 0.02),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 4.7,
                  height: 30,
                  child: Text(eventview.name,
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: notifire.textcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  treding(catList, i) {
    print("516 , home.dart , notifire.getprimerycolor : ${notifire.getprimerycolor}");
    return InkWell(
      onTap: () {
        Get.to(() => TrndingPage(catdata: catList[i]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
              color: notifire.grey1,
              border: Border.all(color: notifire.bordercolore, width: 0.5),
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    image:
                        NetworkImage(catList[i]["iconUrl"]),
                    height: 60
                ),
                SizedBox(width: Get.width * 0.02),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 4.7,
                  height: 30,
                  child: Text(catList[i]["name"],
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: notifire.textcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  imgloading() {
    return Container(
      height: Get.height * 0.20,
      width: Get.width * 0.62,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("image/skeleton.gif"), fit: BoxFit.fill)),
    );
  }

  tredingEvents(tEvent, i) {
    return InkWell(
      onTap: () {
        Get.to(() => EventsDetails(eid: tEvent[i]["event_id"]),
            duration: Duration.zero);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: Get.width * 0.60,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: SizedBox(
                  height: Get.height * 0.20,
                  width: Get.width * 0.62,
                  child: FadeInImage.assetNetwork(
                      fadeInCurve: Curves.easeInCirc,
                      placeholder: "image/skeleton.gif",
                      fit: BoxFit.cover,
                      image: Config.base_url + tEvent[i]["event_img"]),
                ),
              ),
              Positioned(
                top: 8,
                right: Get.width * 0.02,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100/2),
                  child: BackdropFilter(
                    blendMode: BlendMode.srcIn,
                    filter: ImageFilter.blur(
                      sigmaX: 10, // mess with this to update blur
                      sigmaY: 10,
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: LikeButton(
                          onTap: (val) {
                            return onLikeButtonTapped(val, tEvent[i]["event_id"]);
                          },
                          likeBuilder: (bool isLiked) {
                            return tEvent[i]["IS_BOOKMARK"] != 0
                                ? const Icon(Icons.favorite,
                                    color: Color(0xffF0635A), size: 22)
                                : const Icon(Icons.favorite_border,
                                    color: Color(0xffF0635A), size: 22);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Get.height * 0.12,
                    width: Get.width * 0.56,
                    decoration: BoxDecoration(
                        color: notifire.getprimerycolor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: notifire.bordercolore),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.01),
                          Ink(
                            width: Get.width * 0.50,
                            child: Text(tEvent[i]["event_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.textcolor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: Get.height * 0.006),
                          Row(
                            children: [
                              Image.asset("image/location.png",
                                  height: height / 50),
                              SizedBox(width: Get.width * 0.01),
                              Ink(
                                width: Get.width * 0.45,
                                child: Text(tEvent[i]["event_address"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.008),
                          Row(
                            children: [
                              tEvent[i]["sponsore_list"] != null
                                  ? CircleAvatar(
                                      radius: 16.0,
                                      backgroundImage: NetworkImage(
                                          Config.base_url +
                                              tEvent[i]["sponsore_list"]
                                                  ["sponsore_img"]),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : const SizedBox(),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                "Sponser".tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              const Spacer(),
                              Container(
                                height: Get.height * 0.04,
                                width: Get.width * 0.20,
                                decoration: BoxDecoration(
                                    color: buttonColor.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Join".tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Bold',
                                        color: Colors.white,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  homeAppbar() {
    return Container(
      decoration: BoxDecoration(
          color: notifire.backgroundWhite,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      height: Get.height * 0.2,
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.055),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  height: Get.height * 0.06,
                  width: Get.width  * 0.4,
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset("image/p2.png")),
                ),
                Container(
                  height: Get.height * 0.06,
                  color: Colors.transparent,
                  child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset("image/logo.png")),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Current Location".tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Gilroy Medium',
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        getData.read("CurentAdd") ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Gilroy Medium',
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //! ------ Notification Page -----
                    Get.to(() => const Note(), duration: Duration.zero);
                  },
                  child: Image.asset("image/bell.png", height: height / 20),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.015),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: InkWell(
              onTap: () {
                Get.to(() => const SearchPage2());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: notifire.bottommenucolore,
                    borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(3),
                child: Row(
                  children: [
                    Image.asset("image/search.png", height: height / 30),
                    SizedBox(width: width / 90),
                    Container(width: 1, height: height / 40, color: Colors.grey),
                    SizedBox(width: width / 90),
                    //! ------ Search TextField -------
                    Text(
                      "Search...".tr,
                      style: TextStyle(
                          fontFamily: 'Gilroy Medium',
                          color: const Color(0xffd2d2db),
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
              ),
            ),

        ],

      ),
    );
  }

  List<String> _mImages = [];
  Widget monthly(mEvent, i) {
    _mImages.clear();
    mEvent[i]["member_list"].forEach((e) {
      _mImages.add(Config.base_url + e);
    });
    int mEventcount = int.parse(mEvent[i]["total_member_list"].toString()) > 3
        ? 3
        : int.parse(mEvent[i]["total_member_list"].toString());
    for (var i = 0; i < mEventcount; i++) {
      _mImages.add(Config.userImage);
    }
    return GestureDetector(
      onTap: () {
        Get.to(() => EventsDetails(eid: mEvent[i]["event_id"]),
            duration: Duration.zero);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Card(
          color: notifire.getprimerycolor,
          child: Container(
            decoration: BoxDecoration(
                color: notifire.getprimerycolor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            height: height / 6.5,
            width: width,
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            child: SizedBox(
                              width: width / 5,
                              height: height / 8,
                              child: FadeInImage.assetNetwork(
                                  fadeInCurve: Curves.easeInCirc,
                                  placeholder: "image/skeleton.gif",
                                  fit: BoxFit.cover,
                                  image:
                                      Config.base_url + mEvent[i]["event_img"]),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.45,
                                child: Text(
                                  mEvent[i]["event_title"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: notifire.getdarkscolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: height / 100),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("image/location.png",
                                      height: height / 50),
                                  SizedBox(width: Get.width * 0.01),
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Text(
                                      mEvent[i]["event_address"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.grey,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 100),
                              mEvent[i]["total_member_list"] != "0"
                                  ? Row(
                                      children: [
                                        FlutterImageStack(
                                          totalCount: 0,
                                          itemRadius: 30,
                                          itemCount: 3,
                                          itemBorderWidth: 1.5,
                                          imageList: _mImages,
                                        ),
                                        SizedBox(width: Get.width * 0.01),
                                        Text(
                                            "${mEvent[i]["total_member_list"]} + Joined",
                                            style: TextStyle(
                                              color: const Color(0xffF0635A),
                                              fontSize: 12,
                                              fontFamily: 'Gilroy Bold',
                                            )),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          SizedBox(height: height / 80)
                        ],
                      ),
                    ),
                  ],
                ),
                // const Spacer(),
                Column(
                  children: [
                    SizedBox(height: height / 80),
                    Container(
                      decoration: BoxDecoration(
                          color: notifire.getpinkcolor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      height: height / 12,
                      width: width / 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              width: width / 11,
                              child: Text(
                                mEvent[i]["event_sdate"],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy Bold',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width / 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rights(se, name1, name, img, txtcolor, ce) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(img, height: height / 15),
        SizedBox(width: width / 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name1,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy Bold',
                  color: txtcolor),
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Gilroy Normal',
                  color: Colors.grey),
            ),
          ],
        ),
        se,
        ce
      ],
    );
  }

  Widget conference(nearby, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () {
          Get.to(() => EventsDetails(eid: nearby[i]["event_id"]),
              duration: Duration.zero);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: notifire.containercolore,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: notifire.bordercolore)),
          height: height / 7,
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 6, bottom: 5, top: 5),
            child: Row(children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: SizedBox(
                  width: width / 5,
                  height: height / 8,
                  child: FadeInImage.assetNetwork(
                      fadeInCurve: Curves.easeInCirc,
                      placeholder: "image/skeleton.gif",
                      fit: BoxFit.cover,
                      image: Config.base_url + nearby[i]["event_img"]),
                ),
              ),
              Column(children: [
                SizedBox(height: height / 200),
                Row(
                  children: [
                    SizedBox(width: width / 50),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.35,
                                child: Text(
                                  nearby[i]["event_sdate"],
                                  style: const TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: Color(0xff4A43EC),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(width: width * 0.21),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100/2),
                                child: BackdropFilter(
                                  blendMode: BlendMode.srcIn,
                                  filter: ImageFilter.blur(
                                    sigmaX: 10, // mess with this to update blur
                                    sigmaY: 10,
                                  ),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.grey.withOpacity(0.2 ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: LikeButton(
                                        onTap: (val) {
                                          return onLikeButtonTapped(
                                              val, nearby[i]["event_id"]);
                                        },
                                        likeBuilder: (bool isLiked) {
                                          return nearby[i]["IS_BOOKMARK"] != 0
                                              ? const Icon(Icons.favorite,
                                                  color: Color(0xffF0635A),
                                                  size: 22)
                                              : const Icon(Icons.favorite_border,
                                                  color: Color(0xffF0635A),
                                                  size: 22);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: Get.width * 0.55,
                            child: Text(nearby[i]["event_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.textcolor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: height / 200),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "image/location.png",
                                  height: height / 50,
                                ),
                                SizedBox(width: Get.width * 0.01),
                                SizedBox(
                                  width: Get.width * 0.56,
                                  child: Text(
                                    nearby[i]["event_address"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 10),
                                  ),
                                ),
                              ]),
                        ]),
                  ],
                ),
                SizedBox(height: height / 80),
              ])
            ]),
          ),
        ),
      ),
    );
  }

  List<String> upMember = [];
  Widget events(upEvent, i) {
    upMember.clear();
    upEvent["member_list"].forEach((e) {
      upMember.add(Config.base_url + e);
    });
    int membercount = int.parse(upEvent["total_member_list"].toString()) > 3
        ? 3
        : int.parse(upEvent["total_member_list"].toString());
    for (var i = 0; i < membercount; i++) {
      upMember.add(Config.userImage);
    }
    return Stack(children: [
      InkWell(
        onTap: () {
          Get.to(() => EventsDetails(eid: upEvent["event_id"]),
              duration: Duration.zero);
        },
        child: Container(
          color: Colors.transparent,
          width: width / 1.55,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: notifire.bordercolore),
                  borderRadius: BorderRadius.circular(17)),
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height / 5.5,
                      width: width / 1.7,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Stack(
                        children: [
                          //! Event Image
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            child: SizedBox(
                              height: Get.height * 0.20,
                              width: Get.width * 0.62,
                              child: FadeInImage.assetNetwork(
                                  fadeInCurve: Curves.easeInCirc,
                                  placeholder: "image/skeleton.gif",
                                  fit: BoxFit.cover,
                                  image:
                                      Config.base_url + upEvent["event_img"]),
                            ),
                          ),

                          Column(
                            children: [
                              SizedBox(height: height / 70),
                              Row(
                                children: [
                                  SizedBox(width: width / 70),
                                  const Spacer(),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100/2),
                                    child: BackdropFilter(
                                      blendMode: BlendMode.srcIn,
                                      filter: ImageFilter.blur(
                                        sigmaX: 10, // mess with this to update blur
                                        sigmaY: 10,
                                      ),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor:
                                            Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 3),
                                          child: LikeButton(
                                            onTap: (val) {
                                              return onLikeButtonTapped(
                                                  val, upEvent["event_id"]);
                                            },
                                            likeBuilder: (bool isLiked) {
                                              return upEvent["IS_BOOKMARK"] != 0
                                                  ? const Icon(Icons.favorite,
                                                      color: Color(0xffF0635A),
                                                      size: 22)
                                                  : const Icon(
                                                      Icons.favorite_border,
                                                      color: Color(0xffF0635A),
                                                      size: 22);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width / 40),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 40),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      width: Get.width,
                      child: Text(
                        upEvent["event_title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Gilroy Medium',
                            color: notifire.textcolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: height / 140),
                    upEvent["total_member_list"] != "0"
                        ? Row(
                            children: [
                              upEvent["total_member_list"] != "0"
                                  ? FlutterImageStack(
                                      totalCount: 0,
                                      itemRadius: 30,
                                      itemBorderWidth: 1.5,
                                      imageList: upMember)
                                  : const Image(
                                      image: AssetImage("image/user.png"),
                                      height: 28),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                "${upEvent["total_member_list"]} + Going",
                                style: TextStyle(
                                    color: const Color(0xff5d56f3),
                                    fontSize: 11,
                                    fontFamily: 'Gilroy Bold'),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(height: height / 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          Image.asset("image/location.png",
                              height: height / 50),
                          SizedBox(width: Get.width * 0.01),
                          SizedBox(
                            width: Get.width * 0.49,
                            child: Text(
                              upEvent["event_address"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  color: Colors.grey,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: height / 6),
                    Row(children: [
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: notifire.getprimerycolor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        height: height / 30,
                        width: Get.width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width / 4,
                              child: Center(
                                child: Text(
                                  upEvent["event_sdate"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: const Color(0xffF0635A),
                                      fontSize: 11,
                                      fontFamily: 'Gilroy ExtraBold',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width / 40),
                    ]),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    ]);
  }

  Future<void> share() async {
    print("!!!!!.+_.-.-._+.!!!!!" + appName.toString());
    print("!!!!!.+_.-.-._+.!!!!!" + packageName.toString());

    final String text =
        'Hey! Now use our app to share with your family or friends. '
        'User will get wallet amount on your 1st successful transaction. '
        'Enter my referral code $code & Enjoy your shopping !!!';

    final String linkUrl = 'https://play.google.com/store/apps/details?id=$packageName';


  }

  walletrefar() async {
    var data = {"uid": uID};

    ApiWrapper.dataPost(Config.refardata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          code = val["code"];
        } else {
          setState(() {});
        }
      }
    });
  }
}
