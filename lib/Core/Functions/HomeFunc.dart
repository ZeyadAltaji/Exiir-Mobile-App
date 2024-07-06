// import 'dart:math';

// import 'package:ExiirEV/Controller/BaseController.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class HomeFunc extends BaseController
//     with GetSingleTickerProviderStateMixin {
//   late AnimationController animationControllerExplore;
//   late AnimationController animationControllerSearch;
//   late AnimationController animationControllerMenu;
//   late CurvedAnimation curve;
//   late Animation<double> animation;

//   final center = LatLng(0, 0).obs;
//   final markers = <Marker>[].obs;
//   late GoogleMapController mapController;

//   double offsetExplore = 0.0;
//   double offsetSearch = 0.0;
//   double offsetMenu = 0.0;

//   bool isExploreOpen = false;
//   bool isSearchOpen = false;
//   bool isMenuOpen = false;
//   bool isDropdownVisible = false;
//   var mapType = MapType.normal.obs;

//   double get currentExplorePercent =>
//       max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
//   double get currentSearchPercent =>
//       max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
//   double get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));

//   void onSearchHorizontalDragUpdate(DragUpdateDetails details) {
//     offsetSearch = (offsetSearch - details.delta.dx).clamp(0.0, 279.0);
//     update();
//   }

//   void onExploreVerticalUpdate(DragUpdateDetails details) {
//     offsetExplore = (offsetExplore - details.delta.dy).clamp(0.0, 644.0);
//     update();
//   }

//   void animateExplore(bool open) {
//     final duration = Duration(
//       milliseconds: 1 +
//           (800 *
//                   (isExploreOpen
//                       ? currentExplorePercent
//                       : (1 - currentExplorePercent)))
//               .toInt(),
//     );
//     animationControllerExplore =
//         AnimationController(duration: duration, vsync: this);
//     curve =
//         CurvedAnimation(parent: animationControllerExplore, curve: Curves.ease);
//     animation =
//         Tween(begin: offsetExplore, end: open ? 638.0 : 0.0).animate(curve)
//           ..addListener(() {
//             offsetExplore = animation.value;
//             update();
//           })
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               isExploreOpen = open;
//             }
//           });
//     animationControllerExplore.forward();
//   }

//   void animateSearch(bool open) {
//     final duration = Duration(
//       milliseconds: 1 +
//           (800 *
//                   (isSearchOpen
//                       ? currentSearchPercent
//                       : (1 - currentSearchPercent)))
//               .toInt(),
//     );
//     animationControllerSearch =
//         AnimationController(duration: duration, vsync: this);
//     curve =
//         CurvedAnimation(parent: animationControllerSearch, curve: Curves.ease);
//     animation =
//         Tween(begin: offsetSearch, end: open ? 279.0 : 0.0).animate(curve)
//           ..addListener(() {
//             offsetSearch = animation.value;
//             update();
//           })
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               isSearchOpen = open;
//             }
//           });
//     animationControllerSearch.forward();
//   }

//   void animateMenu(bool open) {
//     animationControllerMenu = AnimationController(
//         duration: const Duration(milliseconds: 500), vsync: this);
//     curve =
//         CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
//     animation =
//         Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
//           ..addListener(() {
//             offsetMenu = animation.value;
//             update();
//           })
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               isMenuOpen = open;
//             }
//           });
//     animationControllerMenu.forward();
//   }

//   void toggleDropdownVisibility() {
//     isDropdownVisible = !isDropdownVisible;
//     update();
//   }

//   void changeMapType(MapType type) {
//     mapType.value = type;
//   }

//   @override
//   void onClose() {
//     animationControllerExplore.dispose();
//     animationControllerSearch.dispose();
//     animationControllerMenu.dispose();
//     super.onClose();
//   }
// }
