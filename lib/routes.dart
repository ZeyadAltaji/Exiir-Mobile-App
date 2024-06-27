 
import 'package:exiir3/Views/screens/home_page.dart';
import 'package:exiir3/Views/screens/serch_page.dart';
import 'package:get/get.dart';
 
List<GetPage<dynamic>> routes = [
  
 
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/SerchPage', page: () => SerchPage()),
 

];
 