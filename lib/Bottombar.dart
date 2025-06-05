// ignore_for_file: avoid_print, deprecated_member_use, unnecessary_null_comparison, unnecessary_brace_in_string_interps, unused_element, file_names

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:goevent2/booking/TicketStatus.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/profile/profile.dart';
import 'package:goevent2/utils/Images.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Search/SearchPage.dart';
import 'home/bookmark.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({Key? key}) : super(key: key);

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  late ColorNotifire notifire;

  late int _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 2000;
  int _selectedIndex = 0;
  var isLogin = false;

  final _pageOption = [
    const Home(),
    const SearchPage(),
    const TicketStatusPage(),
    const Bookmark(),
    const Profile(""),
  ];

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    // isLogin = getdata.read("firstLogin") ?? false;

    setState(() {});

  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  String routes = "";
  Future<bool> _handleWillPop() async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
          bottomNavigationBar: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Stack(
            children: [
              ClipPath(
                child: Container(
                  height: 60,
                  color: Color.fromARGB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                            setState(() {
                              _selectedIndex = 0;
                            });
                        },
                        child: Container(
                          width: 68,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.home,
                            width: _selectedIndex == 0 ? 30 : 25,
                            height: _selectedIndex == 0 ? 30 : 25,
                            color: _selectedIndex == 0 ? Colors.blue : Colors.grey,),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Container(
                          width: 68,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.AllEvents,
                            width: _selectedIndex == 1 ? 30 : 25,
                            height: _selectedIndex == 1 ? 30 : 25,
                            color: _selectedIndex == 1 ? Colors.blue : Colors.grey,),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        child: Container(
                          width: 108,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.addd,
                            width: 108
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                        child: Container(
                          width: 68,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.MapView,
                            width: _selectedIndex == 3 ? 30 : 25,
                            height: _selectedIndex == 3 ? 30 : 25,
                            color: _selectedIndex == 3 ? Colors.blue : Colors.grey,),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedIndex = 4;
                          });
                        },
                        child: Container(
                          width: 68,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.MyRSVPs,
                            width: _selectedIndex == 4 ? 30 : 25,
                            height: _selectedIndex == 4 ? 30 : 25,
                            color: _selectedIndex == 4 ? Colors.blue : Colors.grey,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          ),

          // bottomNavigationBar: BottomNavigationBar(
          //     type: BottomNavigationBarType.fixed,
          //     unselectedItemColor: notifire.bottommenucolore,
          //     backgroundColor: notifire.backgrounde,
          //     selectedLabelStyle: const TextStyle(
          //         fontFamily: 'Gilroy_Medium', fontWeight: FontWeight.w500,),
          //     fixedColor: buttonColor,
          //     unselectedFontSize: 13,
          //     selectedFontSize: 13,
          //     unselectedLabelStyle: const TextStyle(fontFamily: 'Gilroy_Medium'),
          //     currentIndex: _selectedIndex,
          //     showSelectedLabels: true,
          //     showUnselectedLabels: true,
          //     items: [
          //       BottomNavigationBarItem(
          //           icon: Image.asset(Images.home,
          //               color: _selectedIndex == 0 ? buttonColor : notifire.bottommenucolore,
          //               height: MediaQuery.of(context).size.height / 35),
          //           label: ""),
          //       BottomNavigationBarItem(
          //           icon: Image.asset(Images.AllEvents,
          //               color: _selectedIndex == 2
          //                   ? buttonColor
          //                   : notifire.bottommenucolore,
          //               height: MediaQuery.of(context).size.height / 35),
          //           label: ''),
          //       BottomNavigationBarItem(
          //         icon: Image.asset(Images.rectangle,
          //             color: _selectedIndex == 3
          //                 ? buttonColor
          //                 : notifire.bottommenucolore,
          //             height: MediaQuery.of(context).size.height / 35),
          //         label: 'Favorite'.tr,
          //       ),
          //       BottomNavigationBarItem(
          //           icon: Image.asset(Images.MapView,
          //               color: _selectedIndex == 1 ?
          //             buttonColor : notifire.bottommenucolore,
          //               height: MediaQuery.of(context).size.height / 33),
          //           label: ''),
          //       BottomNavigationBarItem(
          //         icon: Image.asset(Images.MyRSVPs,
          //             color: _selectedIndex == 4
          //                 ? buttonColor
          //                 : notifire.bottommenucolore,
          //             height: MediaQuery.of(context).size.height / 35),
          //         label: ''
          //       ),
          //     ],
          //     onTap: (index) {
          //       setState(() {});
          //       _selectedIndex = index;
          //     }),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => {
          //   setState(() {
          //     _selectedIndex = 2;
          //   })
          //   },
          //   child: Icon(Icons.add),
          //   backgroundColor: Colors.blue,
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          // bottomNavigationBar: BottomAppBar(
          //   shape: CircularNotchedRectangle(),
          //   notchMargin: 0,
          //   child: BottomNavigationBar(
          //     currentIndex: _selectedIndex == 2 ? 0 : _selectedIndex,
          //     onTap: (index) {
          //         setState(() {});
          //         _selectedIndex = index;
          //     },
          //     type: BottomNavigationBarType.fixed,
          // items: [
          //   BottomNavigationBarItem(
          //       icon: Image.asset(Images.home,
          //           color: _selectedIndex == 0 ? buttonColor : notifire.bottommenucolore,
          //           height: MediaQuery.of(context).size.height / 35),
          //       label: ""),
          //   BottomNavigationBarItem(
          //       icon: Image.asset(Images.AllEvents,
          //           color: _selectedIndex == 2
          //               ? buttonColor
          //               : notifire.bottommenucolore,
          //           height: MediaQuery.of(context).size.height / 35),
          //       label: ''),
          //   BottomNavigationBarItem(
          //     icon: Image.asset(Images.rectangle,
          //         color: _selectedIndex == 3
          //             ? buttonColor
          //             : notifire.bottommenucolore,
          //         height: MediaQuery.of(context).size.height / 35),
          //     label: '',
          //   ),
          //   BottomNavigationBarItem(
          //       icon: Image.asset(Images.MapView,
          //           color: _selectedIndex == 1 ?
          //           buttonColor : notifire.bottommenucolore,
          //           height: MediaQuery.of(context).size.height / 33),
          //       label: ''),
          //   BottomNavigationBarItem(
          //       icon: Image.asset(Images.MyRSVPs,
          //           color: _selectedIndex == 4
          //               ? buttonColor
          //               : notifire.bottommenucolore,
          //           height: MediaQuery.of(context).size.height / 35),
          //       label: ''
          //   ),
          // ],
          //   ),
          // ),
          body: _pageOption[_selectedIndex]),
    );
  }
  //-----------------------------


}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double centerWidth = size.width / 2;
    double fabRadius = 38.0;

    Path path = Path();
    path.lineTo(centerWidth - fabRadius - 20, 0);

    path.quadraticBezierTo(
      centerWidth - fabRadius, 0,
      centerWidth - fabRadius + 10, 20,
    );

    path.arcToPoint(
      Offset(centerWidth + fabRadius - 10, 20),
      radius: Radius.circular(38),
      clockwise: false,
    );

    path.quadraticBezierTo(
      centerWidth + fabRadius, 0,
      centerWidth + fabRadius + 20, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: CurvedBottomNav());
//   }
// }
//
// class CurvedBottomNav extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text('Main Content')),
//       backgroundColor: Colors.grey[200],
//       bottomNavigationBar: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           ClipPath(
//             clipper: NavBarClipper(),
//             child: Container(
//               height: 70,
//               color: Colors.white,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Icon(Icons.home, color: Colors.blue),
//                   Icon(Icons.list, color: Colors.grey),
//                   SizedBox(width: 60), // space for center button
//                   Icon(Icons.person, color: Colors.grey),
//                   Icon(Icons.check, color: Colors.grey),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             child: FloatingActionButton(
//               onPressed: () {},
//               backgroundColor: Colors.blue,
//               child: Icon(Icons.add),
//               elevation: 5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NavBarClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double centerWidth = size.width / 2;
//     double fabRadius = 38.0;
//
//     Path path = Path();
//     path.lineTo(centerWidth - fabRadius - 20, 0);
//
//     path.quadraticBezierTo(
//       centerWidth - fabRadius, 0,
//       centerWidth - fabRadius + 10, 20,
//     );
//
//     path.arcToPoint(
//       Offset(centerWidth + fabRadius - 10, 20),
//       radius: Radius.circular(38),
//       clockwise: false,
//     );
//
//     path.quadraticBezierTo(
//       centerWidth + fabRadius, 0,
//       centerWidth + fabRadius + 20, 0,
//     );
//
//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

