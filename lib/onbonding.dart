// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goevent2/utils/media.dart';
import 'package:goevent2/utils/string.dart';

import 'package:provider/provider.dart';

import 'login_signup/login.dart';
import 'utils/colornotifire.dart';

class Onbonding extends StatefulWidget {
  const Onbonding({Key? key}) : super(key: key);

  @override
  _OnbondingState createState() => _OnbondingState();
}

class _OnbondingState extends State<Onbonding> {
  final int _numPages = 3;

  late ColorNotifire notifire;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    print("29 , _currentPage : ${_currentPage}");

    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 8.0,
      width: isActive ? 15.0 : 8.0,
      decoration: BoxDecoration(
          color: isActive ? Color.fromRGBO(25, 118, 210, 1) : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height / 1.1,
                      child: PageView(
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                            print("75 , _currentPage : ${_currentPage}");
                          });
                        },
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(40, 110, 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset("image/onbonding1.png",
                                      fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,  //Color(0xff5669FF),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          topLeft: Radius.circular(50))),
                                  height: height / 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: height / 30),
                                        Text(
                                          CustomStrings.onbonding1,
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Medium',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                        SizedBox(height: height / 60),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Find and manage events effortlessly. Whether you're a host or an  attendee, stay connected and make every moment count.",
                                                style: TextStyle(
                                                    fontFamily: 'Gilroy Medium',
                                                    color: Color.fromRGBO(96, 96, 96, 1),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(40, 110, 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset("image/onbonding2.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,  //Color(0xff5669FF),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          topLeft: Radius.circular(50))),
                                  height: height / 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: height / 30),
                                        Text(
                                          CustomStrings.onbonding2,
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Medium',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                        SizedBox(height: height / 60),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Stay connected with your friends and make new ones at events.",
                                                style: TextStyle(
                                                    fontFamily: 'Gilroy Medium',
                                                    color: Color.fromRGBO(96, 96, 96, 1),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(40, 110, 0, 0),
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset("image/onbonding3.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,  //Color(0xff5669FF),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          topLeft: Radius.circular(50))),
                                  height: height / 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: height / 30),
                                        Text(
                                          CustomStrings.onbonding3,
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Medium',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                        SizedBox(height: height / 60),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Discover new opportunities and experiences through events.",
                                                style: TextStyle(
                                                    fontFamily: 'Gilroy Medium',
                                                    color: Color.fromRGBO(96, 96, 96, 1),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _currentPage != _numPages - 1
                        ? Container(
                      height: height / 11,
                      color: Colors.white,
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.to(() => const Login(),
                              //         duration: Duration.zero);
                              //   },
                              //   child: Container(
                              //     color: Colors.transparent,
                              //     height: height / 20,
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 15.0),
                              //       child: Center(
                              //         child: Text(
                              //           'Skip',
                              //           style: TextStyle(
                              //               fontFamily: 'Gilroy Medium',
                              //               color: Color(0xff5669FF),
                              //               fontSize: 14),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                color: Colors.white,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _buildPageIndicator()),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     _pageController.nextPage(
                              //         duration:
                              //         const Duration(microseconds: 300),
                              //         curve: Curves.easeIn);
                              //   },
                              //   child: Container(
                              //     color: Colors.transparent,
                              //     height: height / 20,
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 15.0),
                              //       child: Center(
                              //         child: Text(
                              //           'Next',
                              //           style: TextStyle(
                              //               fontFamily: 'Gilroy Medium',
                              //               color: Color(0xff5669FF),
                              //               fontSize: 14),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Container(
                      color: Colors.white,
                      height: height / 11,
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.to(() => const Login(),
                              //         duration: Duration.zero);
                              //   },
                              //   child: Container(
                              //     color: Colors.transparent,
                              //     height: height / 20,
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 15.0),
                              //       child: Center(
                              //         child: Text(
                              //           'Skip',
                              //           style: TextStyle(
                              //               fontFamily: 'Gilroy Medium',
                              //               color: Color(0xff5669FF),
                              //               fontSize: 14),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                color: Colors.white,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _buildPageIndicator()),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.to(() => const Login(),
                              //         duration: Duration.zero);
                              //   },
                              //   child: Container(
                              //     color: Colors.transparent,
                              //     height: height / 20,
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 15.0),
                              //       child: Center(
                              //         child: Text(
                              //           'Start',
                              //           style: TextStyle(
                              //               fontFamily: 'Gilroy Medium',
                              //               color: Color(0xff5669FF),
                              //               fontSize: 14),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    Image.asset(
                      "image/introScreenRow2.png",
                      width: 78.4,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 50,
                      right: 10,
                      child: GestureDetector(
                            onTap: () {
                              Get.offAll(() => const Login(),
                                  duration: Duration.zero);
                            },
                            child: Container(
                              color: Colors.transparent,
                              height: height / 20,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Center(
                                  child: Text(
                                    'Skip >>',
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Color.fromRGBO(160, 162, 164, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.605,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          if(_currentPage <2) {
                            _pageController.nextPage(
                                duration:
                                const Duration(microseconds: 300),
                                curve: Curves.easeIn
                            );
                          }else{
                            Get.offAll(() => const Login(),
                                duration: Duration.zero);
                          }
                        },
                        child: Image.asset(
                          "image/NextButton.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
