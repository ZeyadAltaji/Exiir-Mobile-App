import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Model/Language%20.dart';
import 'package:ExiirEV/Model/Message.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';

import '../Core/Constant/Environment.dart';

class TranslationController extends BaseController {
  var Languages = <int, String>{}.obs;
  var Messages = <int, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLanguage();
    fetchMessages();
  }

  Map<String, String> headers = {
    'KeyToken': Environment.keyToken,
  };
  Future<void> fetchMessages() async {
    try {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);
      final response = await ioClient.get(
          Uri.parse('${Environment.baseUrl}ExiirManagementAPI/GetMessages'),   headers: <String, String>{
           'KeyToken': Environment.keyToken
        });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        data.forEach((item) {
          Message Messagess = Message.fromJson(item);
          if (Messagess.Id != null) {
            Messages[Messagess.Id!] =
                Get.locale?.languageCode == 'ar'
                    ? (Messagess.MsgAr ?? '')
                    : (Messagess.MsgEn ?? '');
          }
        });
      } else {
        throw Exception('Failed to load Languages');
      }
    } catch (e) {
      print('Failed to load Languages + $e');
    }
  }

  Future<void> fetchLanguage() async {
    try {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);
      final response = await ioClient.get(
          Uri.parse('${Environment.baseUrl}ExiirManagementAPI/GetLanguage'),
           headers: <String, String>{
           'KeyToken': Environment.keyToken
        });
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        data.forEach((item) {
          Language language = Language.fromJson(item);
          if (language.id != null) {
            Languages[language.id!] = Get.locale?.languageCode == 'ar'
                ? (language.langDescAr ?? '')
                : (language.langDescEn ?? '');
          }
        });
      } else {
        throw Exception('Failed to load Languages');
      }
    } catch (e) {
      print('Failed to load Languages + $e');
    }
  }

  String getLanguage(int key) {
    return Languages[key] ?? key.toString();
  }

  String GetMessages(int key) {
    return Messages[key] ??  key.toString();
  }

  String Translate(String langDescAr, String langDescEn) {
    if (Get.locale?.languageCode == 'ar') {
      return langDescAr;
    } else {
      return langDescEn;
    }
  }
}
