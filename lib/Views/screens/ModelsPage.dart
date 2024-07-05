import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ExiirEV/Controller/ModelsController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
 import 'package:ExiirEV/Views/Widget/buildModels.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class ModelsPage extends StatelessWidget {
    final int brandId;

  const ModelsPage({Key? key, required this.brandId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ModelsController controller = Get.put(ModelsController(brandId: brandId));
    final TranslationController translationController = Get.put(TranslationController());
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04;
    TextEditingController textController = TextEditingController();

    return Scaffold(
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
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    translationController.getLanguage(86),
                    style: const TextStyle(
                      color: Appcolors.Black,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimSearchBar(
                  width: 440,
                  textController: textController,
                  onSuffixTap: () {
                    textController.clear();
                    controller.searchText.value = '';
                  },
                  helpText: "Search Text...",
                  searchIconColor: Appcolors.Black,
                  autoFocus: true,
                  closeSearchOnSuffixTap: true,
                  animationDurationInMilli: 1500,
                  rtl: true,
                  onSubmitted: (String value) {
                    controller.searchText.value = value;
                  },
                ),
              ),
              Expanded(
                child: Obx(
                  () => controller.filteredModels.isEmpty
                      ? Center(
                          child: Container(
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: Text(
                              translationController.GetMessages('8'),
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.count(
                            physics: const BouncingScrollPhysics(),
                            childAspectRatio: 1 / 1.2,
                            crossAxisCount: size.width < 500 ? 2 : 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: controller.filteredModels
                                .map((models) => GestureDetector(
                                      onTap: () {
                                        // Handle model selection or navigation
                                      },
                                      child: buildModels(models, controller.filteredModels.indexOf(models), size),
                                    ))
                                .toList(),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
