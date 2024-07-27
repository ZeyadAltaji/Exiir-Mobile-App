import 'package:ExiirEV/Controller/CarsController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCars extends StatelessWidget {
  const MyCars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TranslationController translationController =
        Get.put(TranslationController());
    final CarsController carsController = Get.put(CarsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translationController.getLanguage(112),
          textAlign: TextAlign.center,
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
          Expanded(
            child: Obx(() => ListView.separated(
                  itemCount: carsController.lCars.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    final listCar = carsController.lCars[index];
                    return Dismissible(
                      key: Key(listCar.userCar_id.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        carsController.showDeleteDialog(
                            context, listCar.userCar_id!);
                      },
                      child: ListTile(
                        leading: Container(
                          width: 80, // عرض الصورة
                          height: 80, // طول الصورة
                          child: Image.network(
                              '${Environment.imageUrl}/${listCar.br_logo}'),
                        ),
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            carsController.showDeleteDialog(
                                context, listCar.userCar_id!);
                          },
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

class DialogShow extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  DialogShow({required this.onYes, required this.onNo});

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
                SizedBox(height: 30),
                Text(translationController.getLanguage(93)),
                SizedBox(height: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: ElevatedButton(
                          onPressed: onYes,
                          child: Text(translationController.getLanguage(132)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: onNo,
                          child: Text(translationController.getLanguage(133)),
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
              child: Image.asset(
                  AppimageUrlAsset.logo), // Replace with your logo path
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
