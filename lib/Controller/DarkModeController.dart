import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DarkModeController extends GetxController {
  var isDarkMode = false.obs;

  void toggleDarkMode(bool isDark) {
    isDarkMode.value = isDark;
  }

  var items = <ListItem>[
    ListItem(name: 'On'),
    ListItem(name: 'Off'),
    ListItem(name: 'System'),
  ].obs;

  void selectItem(int index) {
    for (int i = 0; i < items.length; i++) {
      items[i].isSelected = i == index;
    }
    items.refresh();

    // Toggle dark mode based on the selection
    if (index == 0) {
      toggleDarkMode(true);
    } else if (index == 1) {
      toggleDarkMode(false);
    }
  }

  int get selectedIndex => items.indexWhere((item) => item.isSelected);
  ThemeData get themeData => isDarkMode.value ? ThemeData.dark() : ThemeData.light();
}

class ListItem {
  final String name;
  bool isSelected;

  ListItem({required this.name, this.isSelected = false});
}
