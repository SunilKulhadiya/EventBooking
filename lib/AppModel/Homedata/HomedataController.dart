// ignore_for_file: unnecessary_overrides, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';

import '../HomeModelEventB.dart';
import 'HomeModelSubData.dart';

String? uID;
Map mainData = {};
String wallet = "";

class HomeController extends GetxController {
  //Map homeDataList = {};
  List homeDataList = [];
  bool isLoading = false;
  bool isLoadingHomeSections = false;
//! -----  Home Page All list -----
  List catlist = [];
  late List<HomeSection> homeSectionsData = [];

  List trendingEvent = [];
  List upcomingEvent = [];
  List nearbyEvent = [];
  List thisMonthEvent = [];

  //! ------- EventsDetails Page Data ---------
  var eventData;
  List event_gallery = [];
  List event_sponsore = [];

  @override
  void onInit() {
    super.onInit();
  }

  homeDataApi(uid, lat, long) {
    isLoading = true;
    update();
    uID = uid;
    print("35 -- HomedataController.dart , uid: ${uid}, lat : ${lat}, long : ${long}");
    var data = {"uid": uid, "lats": lat, "longs": long};
    print("Home Date-->"+data.toString());


    ApiWrapper.dataGet(Config.homecategories).then((val) {
      print("41 -- HomedataController.dart , val : ${val['metadata']['statusCode']}");
      if ((val != null) && (val.isNotEmpty)) {
        if (val['metadata']['statusCode'] == "200" || val['metadata']['statusCode'] == 200) {
      print("43 -- HomedataController.dart , val : ${val['data']}");
          homeDataList = val['data'];
          catlist = val['data'];
          print("45 -- HomedataController.dart , catlist : ${catlist}");
          // trendingEvent = val["HomeData"]["trending_event"];
          // upcomingEvent = val["HomeData"]["upcoming_event"];
          // nearbyEvent = val["HomeData"]["nearby_event"];
          // thisMonthEvent = val["HomeData"]["this_month_event"];
          // mainData = val["HomeData"]["Main_Data"];
          // wallet = val["HomeData"]["wallet"];
          isLoading = false;
          update();
        } else {
          isLoading = false;
          update();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
        update();
      }
    });
  }

  HomeSections(String? uid, String? lat, String? long) {
    isLoadingHomeSections = true;
    update();
    uID = uid;
    print("76 -- HomedataController.dart , uid: ${uid}, lat : ${lat}, long : ${long}");
    var data = {"uid": uid, "lats": lat, "longs": long};
    print("Home Date-->"+data.toString());


    ApiWrapper.getHomeSections(Config.homeSections).then((val) {
      print("84 -- HomedataController.dart , val : ${val['metadata']['statusCode']}");
      if ((val != null) && (val.isNotEmpty)) {
        if (val['metadata']['statusCode'] == "200" ||
            val['metadata']['statusCode'] == 200) {
          print("87 -- HomedataController.dart , val : ${val['data']}");
          final jsonData = val['data'];
          homeSectionsData =
          List<HomeSection>.from(jsonData.map((x) => HomeSection.fromJson(x)));
          print(
              "90 -- HomedataController.dart , homeSectionsData : ${homeSectionsData.length}");

          for (int j = 0; j < homeSectionsData.length; j++) {
            print("98 -- HomedataController.dart , homeSectionsData : ${homeSectionsData[j].displayName}");

            ApiWrapper.getHomeSectionSubData(homeSectionsData[j].apiUrl).then((
                val) {
  print("100 -- HomedataController.dart , val : ${val['metadata']['statusCode']}");
  print("101 -- HomedataController.dart , val['data'] : ${val['data']}");

              if ((val != null) && (val.isNotEmpty) && val['data'] != null) {
                if (val['metadata']['statusCode'] == "200" ||
                    val['metadata']['statusCode'] == 200) {
                  print("106 -- HomedataController.dart , val : ${val['data']}");
                  final jsonData = val['data'];
                  late List<Homemodelsubdata> subdata;
                  subdata = List<Homemodelsubdata>.from(
                      jsonData.map((x) => Homemodelsubdata.fromJson(x)));
        print("111 -- HomedataController.dart , subdata : ${subdata[0].name}");
                  homeSectionsData[j].homemodelsubdata = subdata;
                }
              }
            });

   print("117 -- HomedataController.dart , homeSectionsData[j].homemodelsubdata : ${homeSectionsData[j].homemodelsubdata.length}");

          }

          isLoadingHomeSections = false;
          update();
        } else {
          isLoadingHomeSections = false;
          update();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
        update();
      }
    });
  }

  homeDataReffressApi(uid, lat, long) {
    uID = uid;
    var data = {"uid": uid, "lats": lat, "longs": long};
    print("Home Date-->"+data.toString());

    ApiWrapper.dataPost(Config.homedat, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          homeDataList = val["HomeData"];
          catlist = val["HomeData"]["Catlist"];
          trendingEvent = val["HomeData"]["trending_event"];
          upcomingEvent = val["HomeData"]["upcoming_event"];
          nearbyEvent = val["HomeData"]["nearby_event"];
          thisMonthEvent = val["HomeData"]["this_month_event"];
          mainData = val["HomeData"]["Main_Data"];
          wallet = val["HomeData"]["wallet"];
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
        update();
      }
    });
  }

  eventDetailApi(eid) {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.eventdataApi, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["EventData"].forEach((e) {
            eventData = e;
          });
          update();
          event_gallery = val["Event_gallery"];
          event_sponsore = val["Event_sponsore"];
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
        update();
      }
    });
  }
}
