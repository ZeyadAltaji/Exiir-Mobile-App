import 'package:ExiirEV/Controller/VersionsController.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Views/Widget/buildVersions.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class VersionsPage extends StatelessWidget {
  const VersionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final VersionsController controller =
        Get.put(VersionsController(ModelId: Get.arguments));
    final TranslationController translationController =
        Get.put(TranslationController());
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04;
     final double crossAxisSpacing = size.width * 0.04;
    final double mainAxisSpacing = size.height * 0.04;
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Get.locale!.languageCode == 'ar'
                            ? Icons.keyboard_arrow_right
                            : Icons.keyboard_arrow_left,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        translationController.getLanguage(91),
                        style: const TextStyle(
                          color: Appcolors.Black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 45),
                ],
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
                  helpText: translationController.getLanguage(87),
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
                  () => controller.filteredVersions.isEmpty
                      ? Center(
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
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                           child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size.width < 500 ? 2 : 3,
                            crossAxisSpacing: crossAxisSpacing,
                            mainAxisSpacing: mainAxisSpacing,
                            childAspectRatio: 1 / 1.47,
                          ),
                           itemCount: controller.filteredVersions.length,
                            itemBuilder: (context, index) {
                            final models = controller.filteredVersions[index];
                            return GestureDetector(
                              onTap: () {},
                              child: buildVersions(models, index, size, crossAxisSpacing, mainAxisSpacing),
                            );
                          },
                         
                          ),
                        ),
                ),
              ),
                SizedBox(height: 20), 
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => BookingPage());

                  },
                  child: Text(
                    translationController.getLanguage(92),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),// Adjust as needed
            ],
          ),
        ),
      
      ),
      
    );

  }
}
