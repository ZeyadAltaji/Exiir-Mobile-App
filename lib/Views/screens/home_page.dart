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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      if (offsetExplore > 644) {
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
      child: Stack(
        children: [
          Obx(
            () => GoogleMap(
              mapType: mapType,
              initialCameraPosition: CameraPosition(
                target: controller.center.value,
                zoom: 18.0,
              ),
              markers: Set<Marker>.of(controller.markers),
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              },
              zoomControlsEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomGesturesEnabled: false,
                onCameraMove: controller.onCameraMove,

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
                    color: Colors.white.withOpacity(0.1 * currentSearchPercent),
                    width: screenWidth,
                    height: screenHeight,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(0),
                ),
          //explore content
          ExploreContentWidget(
            currentExplorePercent: currentExplorePercent,
          ),
          //recent search
          RecentSearchWidget(
            currentSearchPercent: currentSearchPercent,
          ),
          //search menu background
          offsetSearch != 0
              ? Positioned(
                  bottom: realH(88),
                  left: realW((standardWidth - 320) / 2),
                  width: realW(320),
                  height: realH(135 * currentSearchPercent),
                  child: Opacity(
                    opacity: currentSearchPercent,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Appcolors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(realW(33)),
                              topRight: Radius.circular(realW(33)))),
                    ),
                  ),
                )
              : const Padding(
                  padding: const EdgeInsets.all(0),
                ),
          //search menu
          SearchMenuWidget(
            currentSearchPercent: currentSearchPercent,
          ),
          //search
          SearchWidget(
            currentSearchPercent: currentSearchPercent,
            currentExplorePercent: currentExplorePercent,
            isSearchOpen: isSearchOpen,
            animateSearch: animateSearch,
            onHorizontalDragUpdate: onSearchHorizontalDragUpdate,
            onPanDown: () => animationControllerSearch?.stop(),
          ),
          //search back
          SearchBackWidget(
            currentSearchPercent: currentSearchPercent,
            animateSearch: animateSearch,
          ),
          Positioned(
              bottom: 300,
              left: 0,
              child: Column(
                children: [
                  if (isDropdownVisible)
                    Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            changeMapType(MapType.satellite);
                          },
                          mini: true,
                          child: Icon(Icons.satellite),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            changeMapType(MapType.normal);
                          },
                          mini: true,
                          child: Icon(Icons.layers),
                        ),
                      ],
                    ),
                  MapButton(
                    currentExplorePercent: currentExplorePercent,
                    currentSearchPercent: currentSearchPercent,
                    bottom: 300,
                    offsetX: -71,
                    width: 71,
                    height: 71,
                    isRight: false,
                    icon: Icons.layers,
                    onTap: () {
                      toggleDropdownVisibility();
                    },
                  ),
                ],
              )),

          MapButton(
            currentExplorePercent: currentExplorePercent,
            currentSearchPercent: currentSearchPercent,
            bottom: 210,
            offsetX: -71,
            width: 68,
            height: 71,
            isRight: false,
            icon: Icons.add,
            onTap: () => controller.zoomIn(),
          ),

          MapButton(
            currentExplorePercent: currentExplorePercent,
            currentSearchPercent: currentSearchPercent,
            bottom: 120,
            offsetX: -71,
            width: 68,
            height: 71,
            isRight: false,
            icon: Icons.remove,
            onTap: () => controller.zoomOut(),
          ),
          //directions button

          //my_location button
          MapButton(
            currentSearchPercent: currentSearchPercent,
            currentExplorePercent: currentExplorePercent,
            bottom: 148,
            offsetX: -68,
            width: 68,
            height: 71,
            icon: Icons.my_location,
            iconColor: Appcolors.blue,
            onTap: () {
              controller.findNearestStation();
            },
          ),
          //menu button
          Positioned(
            bottom: realH(35),
            left: realW(-71 * (currentExplorePercent + currentSearchPercent)),
            child: GestureDetector(
              onTap: () {
                animateMenu(true);
              },
              child: Opacity(
                opacity: 1 - (currentSearchPercent + currentExplorePercent),
                child:  Container(
                  width: realW(71),
                  height: realH(71),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: realW(17)),
                  child:  Icon( 
                    Icons.menu,
                    size:  realW(34),
                  ),
                  decoration: BoxDecoration(
                      color: Appcolors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(realW(36)),
                          topRight: Radius.circular(realW(36))),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            blurRadius: realW(36)),
                      ]),
                ),
              ),
            ),
          ),
          //menu
          MenuWidget(
              currentMenuPercent: currentMenuPercent, animateMenu: animateMenu),
        ],
      ),
    ));
  }
}
