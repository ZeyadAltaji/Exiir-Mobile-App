
import 'package:exiir3/Controller/BaseController.dart';
import 'package:exiir3/Model/Language%20.dart';
import 'package:exiir3/Model/Message.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';

import '../Core/Constant/Environment.dart';
 
class TranslationController extends BaseController {
  var Languages = <String, String>{}.obs;
  var Messages = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLanguage();
    fetchMessages();

  }
   Map<String, String> headers = {
    'KeyToken': Environment.keyToken,
  };
  Future<void> fetchMessages()async {
     try {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);
      final response = await ioClient.get(Uri.parse('${Environment.baseUrl}ExiirManagementAPI/GetMessages'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        data.forEach((item) {
          Message Messagess = Message.fromJson(item);
          if (Messagess.Id != null) {
            Messages[Messagess.Id!.toString()] = Get.locale?.languageCode == 'ar' 
              ? (Messagess.MsgAr ?? '') 
              : (Messagess.MsgEn ?? '');
          }
        });
      } else {
        throw Exception('Failed to load Languages');
      }
    } catch (e) {
      print('Failed to load Languages + $e' );
    }
  }
  Future<void> fetchLanguage() async {
    try {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);
      final response = await ioClient.get(Uri.parse('${Environment.baseUrl}ExiirManagementAPI/GetLanguage')); 
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        data.forEach((item) {
          Language language = Language.fromJson(item);
          if (language.Id != null) {
            Languages[language.Id.toString()] = Get.locale?.languageCode == 'ar' 
              ? (language.LangDescAr ?? '') 
              : (language.LangDescEn ?? '');
          }
        });
      } else {
        throw Exception('Failed to load Languages');
      }
    } catch (e) {
      print('Failed to load Languages + $e' );
    }
  }

  String getLanguage(String key) {
    return Languages[key] ?? key;
  }
  String GetMessages(String key){
    return Messages[key]??key;
  }
}
