import 'dart:math';
import 'dart:ui';

import 'package:ExiirEV/Controller/HomeController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:ExiirEV/Views/Widget/map_button.dart';
import 'package:ExiirEV/Views/Widget/menu_widget.dart';
import 'package:ExiirEV/Views/Widget/recent_search_widget.dart';
import 'package:ExiirEV/Views/Widget/search_back_widget.dart';
import 'package:ExiirEV/Views/Widget/search_menu_widget.dart';
import 'package:ExiirEV/Views/Widget/dropDownbutton.dart';
import 'package:ExiirEV/Views/Widget/ChargingStationModalWidget.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer_pro/sizer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
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
    animationControllerSearch = AnimationController(vsync: this);
    animationControllerMenu = AnimationController(vsync: this);
  }

  @override
  void dispose() {
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
                          bottom: -40.0.h + screenHeight,
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
                  MapButton(
                    currentSearchPercent: currentSearchPercent,
                    currentExplorePercent: currentExplorePercent,
                    bottom: -62.0.h + screenHeight,
                    offsetX: -20.0.w *
                        (currentExplorePercent + currentSearchPercent),
                    width: 17.0.w,
                    height: 10.0.h,
                    icon: Icons.my_location,
                    iconColor: Appcolors.blue,
                    onTap: () {
                      controller.findNearestStation();
                    },
                  ),
                  // toggleDropdownVisibility
                  MapButton(
                    currentExplorePercent: currentExplorePercent,
                    currentSearchPercent: currentSearchPercent,
                    bottom: -50.0.h + screenHeight,
                    offsetX: -20.0.w *
                        (currentExplorePercent + currentSearchPercent),
                    width: 17.0.w,
                    height: 10.0.h,
                    icon: Icons.layers,
                    onTap: () {
                      toggleDropdownVisibility();
                    },
                  ),

//zoomIn
                  MapButton(
                    currentExplorePercent: currentExplorePercent,
                    currentSearchPercent: currentSearchPercent,
                    bottom: -50.0.h + screenHeight,
                    offsetX: -20.0.w *
                        (currentExplorePercent + currentSearchPercent),
                    width: 17.0.w,
                    height: 10.0.h,
                    isRight: false,
                    icon: Icons.add,
                    onTap: () => controller.zoomIn(),
                  ),
                  //zoomOut
                  MapButton(
                    currentExplorePercent: currentExplorePercent,
                    currentSearchPercent: currentSearchPercent,
                    bottom: -62.0.h + screenHeight,
                    offsetX: -20.0.w *
                        (currentExplorePercent + currentSearchPercent),
                    width: 17.0.w,
                    height: 10.0.h,
                    isRight: false,
                    icon: Icons.remove,
                    onTap: () => controller.zoomOut(),
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
        bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.menu, title: translationController.getLanguage(125)),
              TabItem(
                  icon: FontAwesomeIcons.chargingStation,
                  title: translationController.getLanguage(89)),
              TabItem(icon: Icons.search, title: translationController.getLanguage(126)),
            ],
            initialActiveIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  // Close search if it's open and open menu
                                    animateMenu(!isMenuOpen);


                  break;
                case 1:
                  ChargingStationModalHelper.showChargingStationModal(context);

                  break;
                case 2:
                                   animateSearch(!isSearchOpen);

                  break;
              }
            },
            color: Appcolors.white,
            backgroundColor: Appcolors.logoone,
            curveSize: 150,
            elevation: 10));
  }
}
