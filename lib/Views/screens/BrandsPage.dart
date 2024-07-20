import 'package:ExiirEV/Controller/BrandsController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Views/Widget/buildbrand.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stationId = Get.parameters['stationId'];
    final type = Get.parameters['type'];

    final BrandsController controller = Get.put(BrandsController());
    final TranslationController translationController =
        Get.put(TranslationController());
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04;
    TextEditingController textController = TextEditingController();
    final double crossAxisSpacing = size.width * 0.04;
    final double mainAxisSpacing = size.height * 0.04;
    textController.addListener(() {
      controller.searchText.value = textController.text;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.logotwo,
        title: Text(
          textAlign: TextAlign.center,
          translationController.getLanguage(86),
          style: const TextStyle(
            color: Appcolors.Black,
            fontSize: 27,
            fontWeight: FontWeight.bold,
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
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Appcolors.logotwo, Appcolors.logoone],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AnimSearchBar(
                    width: 400,
                    textController: textController,
                    onSuffixTap: () {
                      textController.clear();
                    },
                    helpText: translationController.getLanguage(87),
                    searchIconColor: Appcolors.Black,
                    autoFocus: true,
                    closeSearchOnSuffixTap: true,
                    animationDurationInMilli: 1500,
                    rtl: true,
                    onSubmitted: (String value) {
                      // Empty implementation
                    },
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () {
                    if (controller.filteredBrands.isEmpty) {
                      return Center(
                        child: Container(
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Text(
                            translationController.GetMessages(8),
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size.width < 500 ? 2 : 3,
                            crossAxisSpacing: crossAxisSpacing,
                            mainAxisSpacing: mainAxisSpacing,
                            childAspectRatio: 1 / 1.14,
                          ),
                          itemCount: controller.filteredBrands.length,
                          itemBuilder: (context, index) {
                            final brand = controller.filteredBrands[index];
                            return GestureDetector(
                              onTap: () {},
                              child: buildbrand(brand, index, size,
                                  crossAxisSpacing, mainAxisSpacing,stationId,type),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
