import 'package:ExiirEV/Controller/DarkModeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DarkModeScreens extends StatelessWidget {
  const DarkModeScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DarkModeController listController = Get.put(DarkModeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('On/Off System'),
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: listController.items.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final listItem = listController.items[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {
                          listController.selectItem(index);
                        },
                        leading: Icon(
                          listItem.isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: listItem.isSelected ? Colors.green : Colors.grey,
                        ),
                        title: Text(listItem.name),
                        trailing: Radio(
                          value: index,
                          groupValue: listController.selectedIndex,
                          onChanged: (int? value) {
                            if (value != null) {
                              listController.selectItem(value);
                            }
                          },
                        ),
                      ),
                      if (index == 2 && listController.selectedIndex == 2) // If "System" is selected
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'System: We\'ll adjust your appearance based on your device system setting',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall!.color,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}