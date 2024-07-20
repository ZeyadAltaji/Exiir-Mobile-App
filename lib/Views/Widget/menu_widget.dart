import 'package:ExiirEV/Controller/AccountController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Views/Widget/TextSignUp.dart';
import 'package:flutter/material.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Drawer Menu
class MenuWidget extends StatefulWidget {
  final double? currentMenuPercent;
  final Function(bool)? animateMenu;

  MenuWidget({Key? key, this.currentMenuPercent, this.animateMenu})
      : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  int? selectedIndex;
  final translationController = Get.put(TranslationController());
  final accountController = Get.put(AccountControllerImp());

  late List<String> menuItems;
  @override
  void initState() {
    super.initState();
    menuItems = [
      translationController.getLanguage(112),
      translationController.getLanguage(121),
      translationController.getLanguage(122),
      translationController.getLanguage(123),
    ];
  }

  Future<void> _signOut(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear(); // Clear all SharedPreferences data
    Navigator.pushReplacementNamed(context, '/login'); // Example route
  }

  @override
  Widget build(BuildContext context) {
    return widget.currentMenuPercent != 0
        ? Positioned(
            left: realW(-358 + 358 * widget.currentMenuPercent!),
            width: realW(358),
            height: screenHeight,
            child: Opacity(
              opacity: widget.currentMenuPercent!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(realW(50))),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        blurRadius: realW(20)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (notification) {
                        notification.disallowIndicator();
                        return true;
                      },
                      child: CustomScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              height: realH(236),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(realW(50))),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      colors: [
                                        Color(0xFF59C2FF),
                                        Color(0xFF1270E3),
                                      ])),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: realW(10),
                                    bottom: realH(27),
                                    child: Image.asset(
                                      AppimageUrlAsset.avatar,
                                      width: realH(120),
                                      height: realH(120),
                                    ),
                                  ),
                                  Positioned(
                                    left: realW(60),
                                    bottom: realH(18),
                                    child: Image.asset(
                                      AppimageUrlAsset.lable,
                                      width: realH(72),
                                      height: realH(72),
                                    ),
                                  ),
                                  FutureBuilder<SharedPreferences>(
                                    future: SharedPreferences.getInstance(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        final prefs = snapshot.data;
                                        final isLoggedIn =
                                            prefs?.getString('IsLoged') ==
                                                'true';
                                        return isLoggedIn
                                            ? Positioned(
                                                left: realW(135),
                                                top: realH(110),
                                                child: DefaultTextStyle(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        prefs?.getString(
                                                                'us_username') ??
                                                            'Guest',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                realW(18)),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: realH(
                                                                    11.0)),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text.rich(
                                                            TextSpan(
                                                              text:
                                                                 translationController.getLanguage(124),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      realW(16),
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Positioned(
                                                left: realW(135),
                                                top: realH(135),
                                                child: DefaultTextStyle(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Textsignup(
                                                        textone:
                                                            translationController
                                                                .getLanguage(
                                                                    79),
                                                        textTow:
                                                            translationController
                                                                .getLanguage(5),
                                                        onTap: () {
                                                          accountController
                                                              .GoToPageLoginPage();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(
                                top: realH(34),
                                bottom: realH(50),
                                right: realW(37)),
                            sliver: SliverFixedExtentList(
                              itemExtent: realH(56),
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                final isSelected = selectedIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                    if (index == menuItems.length - 1) {
                                      _signOut(context);
                                    }
                                  },
                                  child: Container(
                                    width: realW(321),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: realW(20)),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color(0xFF379BF2).withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(realW(50)),
                                          bottomRight:
                                              Radius.circular(realW(50))),
                                    ),
                                    child: Text(
                                      menuItems[index],
                                      style: TextStyle(
                                          color: isSelected
                                              ? Color(0xFF379BF2)
                                              : Colors.black,
                                          fontSize: realW(20)),
                                    ),
                                  ),
                                );
                              }, childCount: menuItems.length),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // close button
                    Positioned(
                      bottom: realH(53),
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          widget.animateMenu!(false);
                        },
                        child: Container(
                          width: realW(71),
                          height: realH(71),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: realW(17)),
                          child: Icon(
                            Icons.close,
                            color: Color(0xFFE96977),
                            size: realW(34),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFB5E74).withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(realW(36)),
                                topLeft: Radius.circular(realW(36))),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : const Padding(padding: EdgeInsets.all(0));
  }
}
