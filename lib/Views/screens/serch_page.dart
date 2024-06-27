import 'package:exiir3/Controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

 import '../base/card_stations.dart';

class SerchPage extends StatelessWidget {
  const SerchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Serch",
          style: TextStyle(fontSize: 25.sp),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextFormField(
                // controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  labelText: 'Serch',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  // Optional: Customize other properties such as labelStyle, hintText, etc.
                ),
              ),
            ),
            // Expanded(
            //   child: SizedBox(
            //     child: ListView.builder(
            //       itemCount: Provider.of<HomeController >(context, listen: false)
            //           .stations
            //           .length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return ListTile(
            //           title: CardStations(
            //             stations:
            //                 // Provider.of<HomeController >(context, listen: false)
            //                 //     .stations[index],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
