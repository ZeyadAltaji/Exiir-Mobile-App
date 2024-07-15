
import 'package:ExiirEV/Controller/CarsController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListandAddnewCars extends StatelessWidget {
  const ListandAddnewCars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TranslationController translationController =
        Get.put(TranslationController());
    final CarsController carsController = Get.put(CarsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(translationController.getLanguage(111)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translationController.getLanguage(112),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.BrandsPageAdd);
                  },
                  child: Text(translationController.getLanguage(113)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => ListView.separated(
              itemCount: carsController.lCars.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final listCar = carsController.lCars[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.BookingPage);
                  },
                  child: ListTile(
                    leading: Image.network(
                        '${Environment.imageUrl}/${listCar.br_logo}'),
                    title: Text(translationController.Translate(
                        listCar.br_name_ar ?? '', listCar.br_name ?? '')),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${translationController.getLanguage(114)} - ${translationController.Translate(listCar.mo_name_ar ?? '', listCar.ve_name ?? '')}'),
                        Text('${translationController.getLanguage(115)} - ${listCar.ve_name}'),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
