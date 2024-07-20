import 'package:ExiirEV/Controller/CarsController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final stationId = Get.parameters['stationId'];

class ListandAddnewCars extends StatelessWidget {
  const ListandAddnewCars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TranslationController translationController =
        Get.put(TranslationController());
    final CarsController carsController = Get.put(CarsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          translationController.getLanguage(86),
          style: const TextStyle(
            color: Appcolors.Black,
            fontSize: 27,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            color: Appcolors.Black,
            onPressed: () {
              Get.offAllNamed(AppRoutes.HomePage);
            },
          ),
        ],
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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Get.toNamed(AppRoutes.BrandsPageAdd);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return dialogshow();
                      },
                    );
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
                         final String route = stationId != null
                                ? '${AppRoutes.BookingPage}?stationId=$stationId&type=${1}&BrandId=${listCar.br_id}&ModelId=${listCar.mo_id}&VersionsId=${listCar.ve_id}' 
                                : AppRoutes.BookingPage;
                        Get.toNamed(route);
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
                            Text(
                                '${translationController.getLanguage(115)} - ${listCar.ve_name}'),
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

class dialogshow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: 150,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            final String route = stationId != null
                                ? '${AppRoutes.BrandsPageAdd}?stationId=$stationId&type=${2}' 
                                : AppRoutes.BrandsPageAdd;

                            Get.toNamed(route);
                          },
                          child: Text(translationController.getLanguage(116)),
                        ),
                      ),
                     const SizedBox(width: 10),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            final String route = stationId != null
                                ? '${AppRoutes.BrandsPageAdd}?stationId=$stationId&type=${1}' 
                                : AppRoutes.BrandsPageAdd;

                            Get.toNamed(route);
                          },
                          child: Text(translationController.getLanguage(117)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -50,
            child: CircleAvatar(
              radius: 50,
              child: Image.asset(AppimageUrlAsset.logo),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
