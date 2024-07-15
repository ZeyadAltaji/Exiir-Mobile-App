// import 'dart:math';
// import 'dart:ui';

// import 'package:ExiirEV/Controller/HomeController.dart';
// import 'package:ExiirEV/Core/Constant/AppColors.dart';
// import 'package:ExiirEV/Core/Functions/helper.dart';
// import 'package:ExiirEV/Views/Widget/explore_content_widget.dart';
// import 'package:ExiirEV/Views/Widget/explore_widget.dart';
// import 'package:ExiirEV/Views/Widget/map_button.dart';
// import 'package:ExiirEV/Views/Widget/menu_widget.dart';
// import 'package:ExiirEV/Views/Widget/recent_search_widget.dart';
// import 'package:ExiirEV/Views/Widget/search_back_widget.dart';
// import 'package:ExiirEV/Views/Widget/search_menu_widget.dart';
// import 'package:ExiirEV/Views/Widget/search_widget.dart';
// import 'package:ExiirEV/Views/Widget/dropDownbutton.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   final HomeController controller = Get.put(HomeController());
//   late AnimationController animationControllerExplore;
//   late AnimationController animationControllerSearch;
//   late AnimationController animationControllerMenu;
//   late CurvedAnimation curve;
//   late Animation<double> animation;

//   double offsetExplore = 0.0;
//   double offsetSearch = 0.0;
//   double offsetMenu = 0.0;

//   bool isExploreOpen = false;
//   bool isSearchOpen = false;
//   bool isMenuOpen = false;
//   bool isDropdownVisible = false;
//   MapType mapType = MapType.normal;
//   double get currentExplorePercent =>
//       max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
//   double get currentSearchPercent =>
//       max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
//   double get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));
//   @override
//   void initState() {
//     super.initState();
//     animationControllerExplore = AnimationController(vsync: this);
//     animationControllerSearch = AnimationController(vsync: this);
//     animationControllerMenu = AnimationController(vsync: this);
//   }

//   @override
//   void dispose() {
//     animationControllerExplore.dispose();
//     animationControllerSearch.dispose();
//     animationControllerMenu.dispose();
//     super.dispose();
//   }

//   void onSearchHorizontalDragUpdate(details) {
//     setState(() {
//       offsetSearch -= details.delta.dx;
//       if (offsetSearch < 0) {
//         offsetSearch = 0;
//       } else if (offsetSearch > (347 - 68.0)) {
//         offsetSearch = 347 - 68.0;
//       }
//     });
//   }

//   void onExploreVerticalUpdate(details) {
//     setState(() {
//       offsetExplore -= details.delta.dy;
//       if (offsetExplore <= 644) {
//         offsetExplore = 644;
//       } else if (offsetExplore < 0) {
//         offsetExplore = 0;
//       }
//     });
//   }

//   void animateExplore(bool open) {
//     animationControllerExplore = AnimationController(
//       duration: Duration(
//         milliseconds: 1 +
//             (800 *
//                     (isExploreOpen
//                         ? currentExplorePercent
//                         : (1 - currentExplorePercent)))
//                 .toInt(),
//       ),
//       vsync: this,
//     );
//     curve =
//         CurvedAnimation(parent: animationControllerExplore, curve: Curves.ease);
//     animation = Tween(begin: offsetExplore, end: open ? 760.0 - 122 : 0.0)
//         .animate(curve)
//       ..addListener(() {
//         setState(() {
//           offsetExplore = animation.value;
//         });
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           isExploreOpen = open;
//         }
//       });
//     animationControllerExplore.forward();
//   }

//   void animateSearch(bool open) {
//     animationControllerSearch = AnimationController(
//       duration: Duration(
//         milliseconds: 1 +
//             (800 *
//                     (isSearchOpen
//                         ? currentSearchPercent
//                         : (1 - currentSearchPercent)))
//                 .toInt(),
//       ),
//       vsync: this,
//     );
//     curve =
//         CurvedAnimation(parent: animationControllerSearch, curve: Curves.ease);
//     animation = Tween(begin: offsetSearch, end: open ? 347.0 - 68.0 : 0.0)
//         .animate(curve)
//       ..addListener(() {
//         setState(() {
//           offsetSearch = animation.value;
//         });
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           isSearchOpen = open;
//         }
//       });
//     animationControllerSearch.forward();
//   }

//   void animateMenu(bool open) {
//     animationControllerMenu =
//         AnimationController(duration: Duration(milliseconds: 500), vsync: this);
//     curve =
//         CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
//     animation =
//         Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
//           ..addListener(() {
//             setState(() {
//               offsetMenu = animation.value;
//             });
//           })
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               isMenuOpen = open;
//             }
//           });
//     animationControllerMenu.forward();
//   }

//   void toggleDropdownVisibility() {
//     setState(() {
//       isDropdownVisible = !isDropdownVisible;
//     });
//   }

//   void changeMapType(MapType type) {

//     setState(() {
//       mapType = type;
//        toggleDropdownVisibility();
//       // Update your GoogleMap widget's map type here
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: SizedBox(
//       width: screenWidth,
//       height: screenHeight,
//       child: Stack(
//         children: [
//           Obx(
//             () => GoogleMap(
//               mapType: mapType,
//               initialCameraPosition: CameraPosition(
//                 target: controller.center.value,
//                 zoom: 10.0,
//               ),
//               markers: Set<Marker>.of(controller.markers),
//               onMapCreated: (GoogleMapController mapController) {
//                 controller.mapController = mapController;
//               },
//               zoomControlsEnabled: false,
//             ),
//           ),
//           ExploreWidget(
//             currentExplorePercent: currentExplorePercent,
//             currentSearchPercent: currentSearchPercent,
//             animateExplore: animateExplore,
//             isExploreOpen: isExploreOpen,
//             onVerticalDragUpdate: onExploreVerticalUpdate,
//             onPanDown: () => animationControllerExplore?.stop(),
//           ),
//           offsetSearch != 0
//               ? BackdropFilter(
//                   filter: ImageFilter.blur(
//                       sigmaX: 10 * currentSearchPercent,
//                       sigmaY: 10 * currentSearchPercent),
//                   child: Container(
//                     color: Colors.white.withOpacity(0.1 * currentSearchPercent),
//                     width: screenWidth,
//                     height: screenHeight,
//                   ),
//                 )
//               : const Padding(
//                   padding: EdgeInsets.all(0),
//                 ),
//           //  explore content
//           ExploreContentWidget(
//             currentExplorePercent: currentExplorePercent,
//           ),
//           //recent search
//           RecentSearchWidget(
//             currentSearchPercent: currentSearchPercent,
//           ),
//           //search menu background
//           offsetSearch != 0
//               ? Positioned(
//                   bottom: realH(500),
//                   left: realW((standardWidth - 320) / 2),
//                   width: realW(320),
//                   height: realH(135 * currentSearchPercent),
//                   child: Opacity(
//                     opacity: currentSearchPercent,
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                           color: Appcolors.white,
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(realW(33)),
//                               topRight: Radius.circular(realW(33)))),
//                     ),
//                   ),
//                 )
//               : const Padding(
//                   padding: const EdgeInsets.all(0),
//                 ),
//           //search menu
//           SearchMenuWidget(
//             currentSearchPercent: currentSearchPercent,
//           ),
//           //search
//           SearchWidget(
//             currentSearchPercent: currentSearchPercent,
//             currentExplorePercent: currentExplorePercent,
//             isSearchOpen: isSearchOpen,
//             animateSearch: animateSearch,
//             onHorizontalDragUpdate: onSearchHorizontalDragUpdate,
//             onPanDown: () => animationControllerSearch?.stop(),
//           ),
//           //search back
//           SearchBackWidget(
//             currentSearchPercent: currentSearchPercent,
//             animateSearch: animateSearch,
//           ),

//          Container(
//     child: Visibility(
//     visible: isDropdownVisible,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         DropDownbutton(
//           currentExplorePercent: currentExplorePercent,
//           currentSearchPercent: currentSearchPercent,
//           bottom: realH(5),
//           width: 55,
//                         offsetX: -68,

//           height: 55,
//           isRight: true,
//           icon: Icons.satellite,
//           onTap: () => changeMapType(MapType.satellite),
//         ),
//          DropDownbutton(
//           currentExplorePercent: currentExplorePercent,
//           currentSearchPercent: currentSearchPercent,
//           bottom: realH(370),
//                         offsetX: 100,

//           width: 55,
//           height: 55,
//           isRight: true,
//           icon: Icons.layers,
//           onTap: () => changeMapType(MapType.normal),
//         ),
//       ],
//     ),
//   ),
// ),

//             MapButton(
//               currentExplorePercent: currentExplorePercent,
//               currentSearchPercent: currentSearchPercent,
//               bottom: realH(300),
//               offsetX: -68,
//               width: 71,
//               height: 71,
//               icon: Icons.layers,
//               onTap: () {
//                 toggleDropdownVisibility();
//               },
//             ),

//           MapButton(
//             currentExplorePercent: currentExplorePercent,
//             currentSearchPercent: currentSearchPercent,
//             bottom: realH(305),
//             offsetX: -71,
//             width: 68,
//             height: 71,
//             isRight: false,
//             icon: Icons.add,
//             onTap: () => controller.zoomIn(),
//           ),

//           MapButton(
//             currentExplorePercent: currentExplorePercent,
//             currentSearchPercent: currentSearchPercent,
//             bottom: realH(220),
//             offsetX: -71,
//             width: 68,
//             height: 71,
//             isRight: false,
//             icon: Icons.remove,
//             onTap: () => controller.zoomOut(),
//           ),
//           // //directions button

//           // //my_location button
//           MapButton(
//             currentSearchPercent: currentSearchPercent,
//             currentExplorePercent: currentExplorePercent,
//             bottom: realH(220),
//             offsetX: -68,
//             width: 68,
//             height: 71,
//             icon: Icons.my_location,
//             iconColor: Appcolors.blue,
//             onTap: () {
//               controller.findNearestStation();
//             },
//           ),
//           // //menu button
//           Positioned(
//             bottom: realH(145),
//             left: realW(-71 * (currentExplorePercent + currentSearchPercent)),
//             child: GestureDetector(
//               onTap: () {
//                 animateMenu(true);
//               },
//               child: Opacity(
//                 opacity: 1 - (currentSearchPercent + currentExplorePercent),
//                 child: Container(
//                   width: realW(71),
//                   height: realH(71),
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: realW(17)),
//                   child: Icon(
//                     Icons.menu,
//                     size: realW(34),
//                   ),
//                   decoration: BoxDecoration(
//                       color: Appcolors.white,
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(realW(36)),
//                           topRight: Radius.circular(realW(36))),
//                       boxShadow: [
//                         BoxShadow(
//                             color: const Color.fromRGBO(0, 0, 0, 0.3),
//                             blurRadius: realW(36)),
//                       ]),
//                 ),
//               ),
//             ),
//           ),
//           // //menu
//           MenuWidget(
//               currentMenuPercent: currentMenuPercent, animateMenu: animateMenu),
//         ],
//       ),
//     ));
//   }
// }
import 'dart:math';
import 'dart:ui';

import 'package:ExiirEV/Controller/HomeController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:ExiirEV/Views/Widget/explore_content_widget.dart';
import 'package:ExiirEV/Views/Widget/explore_widget.dart';
import 'package:ExiirEV/Views/Widget/map_button.dart';
import 'package:ExiirEV/Views/Widget/menu_widget.dart';
import 'package:ExiirEV/Views/Widget/recent_search_widget.dart';
import 'package:ExiirEV/Views/Widget/search_back_widget.dart';
import 'package:ExiirEV/Views/Widget/search_menu_widget.dart';
import 'package:ExiirEV/Views/Widget/search_widget.dart';
import 'package:ExiirEV/Views/Widget/dropDownbutton.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer_pro/sizer.dart'; // Import sizer package

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  late AnimationController animationControllerExplore;
  late AnimationController animationControllerSearch;
  late AnimationController animationControllerMenu;
  late CurvedAnimation curve;
  late Animation<double> animation;

  double offsetExplore = 0.0;
  double offsetSearch = 0.0;
  double offsetMenu = 0.0;

  bool isExploreOpen = false;
  bool isSearchOpen = false;
  bool isMenuOpen = false;
  bool isDropdownVisible = false;
  MapType mapType = MapType.normal;
  double get currentExplorePercent =>
      max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  double get currentSearchPercent =>
      max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
  double get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));

  @override
  void initState() {
    super.initState();
    animationControllerExplore = AnimationController(vsync: this);
    animationControllerSearch = AnimationController(vsync: this);
    animationControllerMenu = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationControllerExplore.dispose();
    animationControllerSearch.dispose();
    animationControllerMenu.dispose();
    super.dispose();
  }

  void onSearchHorizontalDragUpdate(details) {
    setState(() {
      offsetSearch -= details.delta.dx;
      if (offsetSearch < 0) {
        offsetSearch = 0;
      } else if (offsetSearch > (347 - 68.0)) {
        offsetSearch = 347 - 68.0;
      }
    });
  }

  void onExploreVerticalUpdate(details) {
    setState(() {
      offsetExplore -= details.delta.dy;
      if (offsetExplore <= 644) {
        offsetExplore = 644;
      } else if (offsetExplore < 0) {
        offsetExplore = 0;
      }
    });
  }

  void animateExplore(bool open) {
    animationControllerExplore = AnimationController(
      duration: Duration(
        milliseconds: 1 +
            (800 *
                    (isExploreOpen
                        ? currentExplorePercent
                        : (1 - currentExplorePercent)))
                .toInt(),
      ),
      vsync: this,
    );
    curve =
        CurvedAnimation(parent: animationControllerExplore, curve: Curves.ease);
    animation = Tween(begin: offsetExplore, end: open ? 760.0 - 122 : 0.0)
        .animate(curve)
      ..addListener(() {
        setState(() {
          offsetExplore = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isExploreOpen = open;
        }
      });
    animationControllerExplore.forward();
  }

  void animateSearch(bool open) {
    animationControllerSearch = AnimationController(
      duration: Duration(
        milliseconds: 1 +
            (800 *
                    (isSearchOpen
                        ? currentSearchPercent
                        : (1 - currentSearchPercent)))
                .toInt(),
      ),
      vsync: this,
    );
    curve =
        CurvedAnimation(parent: animationControllerSearch, curve: Curves.ease);
    animation = Tween(begin: offsetSearch, end: open ? 347.0 - 68.0 : 0.0)
        .animate(curve)
      ..addListener(() {
        setState(() {
          offsetSearch = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isSearchOpen = open;
        }
      });
    animationControllerSearch.forward();
  }

  void animateMenu(bool open) {
    animationControllerMenu =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
    animation =
        Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
          ..addListener(() {
            setState(() {
              offsetMenu = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isMenuOpen = open;
            }
          });
    animationControllerMenu.forward();
  }

  void toggleDropdownVisibility() {
    setState(() {
      isDropdownVisible = !isDropdownVisible;
    });
  }

  void changeMapType(MapType type) {
    setState(() {
      mapType = type;
      toggleDropdownVisibility();
      // Update your GoogleMap widget's map type here
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Stack(
              children: [
                Obx(
                  () => GoogleMap(
                    mapType: mapType,
                    initialCameraPosition: CameraPosition(
                      target: controller.center.value,
                      zoom: 10.0,
                    ),
                    markers: Set<Marker>.of(controller.markers),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                    },
                    zoomControlsEnabled: false,
                  ),
                ),
                ExploreWidget(
                  currentExplorePercent: currentExplorePercent,
                  currentSearchPercent: currentSearchPercent,
                  animateExplore: animateExplore,
                  isExploreOpen: isExploreOpen,
                  onVerticalDragUpdate: onExploreVerticalUpdate,
                  onPanDown: () => animationControllerExplore?.stop(),
                ),
                offsetSearch != 0
                    ? BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 10 * currentSearchPercent,
                            sigmaY: 10 * currentSearchPercent),
                        child: Container(
                          color: Colors.white
                              .withOpacity(0.1 * currentSearchPercent),
                          width: screenWidth,
                          height: screenHeight,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(0),
                      ),
                ExploreContentWidget(
                  currentExplorePercent: currentExplorePercent,
                ),
                RecentSearchWidget(
                  currentSearchPercent: currentSearchPercent,
                ),
                offsetSearch != 0
                    ? Positioned(
                        bottom: 5.0.h,
                        left: (375 - 320) / 2.0.w,
                        width: 320.0.w,
                        height: (135 * currentSearchPercent).h,
                        child: Opacity(
                          opacity: currentSearchPercent,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Appcolors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(33.0.w),
                                topRight: Radius.circular(33.0.w),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Padding(padding: EdgeInsets.all(0)),
                SearchMenuWidget(
                  currentSearchPercent: currentSearchPercent,
                ),
                //SearchWidget
                // SearchWidget(
                //   currentSearchPercent: currentSearchPercent,
                //   currentExplorePercent: currentExplorePercent,
                //   isSearchOpen: isSearchOpen,
                //   animateSearch: animateSearch,
                //   onHorizontalDragUpdate: onSearchHorizontalDragUpdate,
                //   onPanDown: () => animationControllerSearch?.stop(),
                //   offsetX: 20.0.w,
                // ),
                SearchBackWidget(
                  currentSearchPercent: currentSearchPercent,
                  animateSearch: animateSearch,
                ),
                Visibility(
                  visible: isDropdownVisible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropDownbutton(
                        currentExplorePercent: currentExplorePercent,
                        currentSearchPercent: currentSearchPercent,
                        bottom: 1.0.h,
                        width: 12.0.w,
                        offsetX: -68.0.w,
                        height: 8.0.h,
                        isRight: true,
                        icon: Icons.satellite,
                        onTap: () => changeMapType(MapType.satellite),
                      ),
                      DropDownbutton(
                        currentExplorePercent: currentExplorePercent,
                        currentSearchPercent: currentSearchPercent,
                        bottom: 62.0.h,
                        offsetX: 100.0.w,
                        width: 12.0.w,
                        height: 8.0.h,
                        isRight: true,
                        icon: Icons.layers,
                        onTap: () => changeMapType(MapType.normal),
                      ),
                    ],
                  ),
                ),
                //findNearestStation
                // MapButton(
                //   currentSearchPercent: currentSearchPercent,
                //   currentExplorePercent: currentExplorePercent,
                //   bottom: 37.0.h,
                //   offsetX:
                //       -20.0.w * (currentExplorePercent + currentSearchPercent),
                //   width: 17.0.w,
                //   height: 10.0.h,
                //   icon: Icons.my_location,
                //   iconColor: Appcolors.blue,
                //   onTap: () {
                //     controller.findNearestStation();
                //   },
                // ),
                // // toggleDropdownVisibility
                // MapButton(
                //   currentExplorePercent: currentExplorePercent,
                //   currentSearchPercent: currentSearchPercent,
                //   bottom: 50.0.h,
                //   offsetX:
                //       -20.0.w * (currentExplorePercent + currentSearchPercent),
                //   width: 17.0.w,
                //   height: 10.0.h,
                //   icon: Icons.layers,
                //   onTap: () {
                //     toggleDropdownVisibility();
                //   },
                // ),
               // Group 1: SearchWidget, findNearestStation, toggleDropdownVisibility
              Positioned(
                bottom: 37.0.h, 
                right:  -21.0.w * (currentExplorePercent + currentSearchPercent),
                child: Container(
                  child: Column(
                    children: [
                     MapButton(
                        currentExplorePercent: currentExplorePercent,
                        currentSearchPercent: currentSearchPercent,
                        bottom: 50.0.h,
                        offsetX: -20.0.w * (currentExplorePercent + currentSearchPercent),
                        width: 21.0.w,
                        height: 10.0.h,
                        icon: Icons.layers,
                        onTap: () {
                          toggleDropdownVisibility();
                        },
                      ),
                      SizedBox(height: 3.5.h),
                      MapButton(
                        currentSearchPercent: currentSearchPercent,
                        currentExplorePercent: currentExplorePercent,
                        bottom: 37.0.h,
                        offsetX: -20.0.w * (currentExplorePercent + currentSearchPercent),
                        width: 21.0.w,
                        height: 10.0.h,
                        icon: Icons.my_location,
                        iconColor: Appcolors.blue,
                        onTap: () {
                          controller.findNearestStation();
                        },
                      ),
                      SizedBox(height: 3.5.h),
                       SearchWidget(
                        currentSearchPercent: currentSearchPercent,
                        currentExplorePercent: currentExplorePercent,
                        isSearchOpen: isSearchOpen,
                        animateSearch: animateSearch,
                        onHorizontalDragUpdate: onSearchHorizontalDragUpdate,
                        onPanDown: () => animationControllerSearch?.stop(),
                        offsetX: 20.0.w,
                      ),
                    ],
                  ),
                ),
              ),

// //zoomIn
//                 MapButton(
//                   currentExplorePercent: currentExplorePercent,
//                   currentSearchPercent: currentSearchPercent,
//                   bottom: 50.0.h,
//                   offsetX:
//                       -20.0.w * (currentExplorePercent + currentSearchPercent),
//                   width: 17.0.w,
//                   height: 10.0.h,
//                   isRight: false,
//                   icon: Icons.add,
//                   onTap: () => controller.zoomIn(),
//                 ),
//                 //zoomOut
//                 MapButton(
//                   currentExplorePercent: currentExplorePercent,
//                   currentSearchPercent: currentSearchPercent,
//                   bottom: 37.0.h,
//                   offsetX:
//                       -20.0.w * (currentExplorePercent + currentSearchPercent),
//                   width: 17.0.w,
//                   height: 10.0.h,
//                   isRight: false,
//                   icon: Icons.remove,
//                   onTap: () => controller.zoomOut(),
//                 ),
            
//                 Positioned(
//                   bottom: 26.0.h,
//                   left:
//                       -20.0.w * (currentExplorePercent + currentSearchPercent),
//                   child: GestureDetector(
//                     onTap: () {
//                       animateMenu(true);
//                     },
//                     child: Opacity(
//                       opacity:
//                           1 - (currentSearchPercent + currentExplorePercent),
//                       child: Container(
//                         width: 17.0.w,
//                         height: 10.0.h,
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(left: 3.0.w),
//                         child: Icon(
//                           Icons.menu,
//                           size: 10.0.w,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Appcolors.white,
//                           borderRadius: BorderRadius.only(
//                             bottomRight: Radius.circular(36.0.w),
//                             topRight: Radius.circular(36.0.w),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(0, 0, 0, 0.3),
//                               blurRadius: 36.0.w,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 //animateMenu
//                 MenuWidget(
//                   currentMenuPercent: currentMenuPercent,
//                   animateMenu: animateMenu,
//                 ),
//               ],
// Group 2: zoomIn, zoomOut, animateMenu
              Positioned(
                bottom: 37.0.h, // Adjust the bottom value as needed
                left:
                      -21.0.w * (currentExplorePercent + currentSearchPercent),
                child: Container(
                  child: Column(
                    children: [
                      MapButton(
                        currentExplorePercent: currentExplorePercent,
                        currentSearchPercent: currentSearchPercent,
                        bottom: 50.0.h,
                        offsetX: -20.0.w * (currentExplorePercent + currentSearchPercent),
                        width:21.0.w,
                        height: 10.0.h,
                        isRight: false,
                        icon: Icons.add,
                        onTap: () => controller.zoomIn(),
                      ),
                      SizedBox(height: 3.5.h), // Space between buttons
                      MapButton(
                        currentExplorePercent: currentExplorePercent,
                        currentSearchPercent: currentSearchPercent,
                        bottom: 37.0.h,
                        offsetX: -20.0.w * (currentExplorePercent + currentSearchPercent),
                        width: 21.0.w,
                        height: 10.0.h,
                        isRight: false,
                        icon: Icons.remove,
                        onTap: () => controller.zoomOut(),
                      ),
                      SizedBox(height: 3.5.h), // Space between buttons
                      Positioned(
                        bottom: 26.0.h,
                        left: -20.0.w * (currentExplorePercent + currentSearchPercent),
                        child: GestureDetector(
                          onTap: () {
                            animateMenu(true);
                          },
                          child: Opacity(
                            opacity: 1 - (currentSearchPercent + currentExplorePercent),
                            child: Container(
                              width: 21.0.w,
                              height: 10.0.h,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 3.0.w),
                              child: Icon(
                                Icons.menu,
                                size: 10.0.w,
                              ),
                              decoration: BoxDecoration(
                                color: Appcolors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(36.0.w),
                                  topRight: Radius.circular(36.0.w),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    blurRadius: 36.0.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //animateMenu
              MenuWidget(
                currentMenuPercent: currentMenuPercent,
                animateMenu: animateMenu,
              ),
            ],
            );
          },
        ),
      ),
    );
  }
}
