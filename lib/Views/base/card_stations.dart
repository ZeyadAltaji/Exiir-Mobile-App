import 'package:exiir3/Model/StationsModels.dart';
import 'package:exiir3/helper/constants/utils/image_pathe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

 
class CardStations extends StatelessWidget {
  final StationsModels stations;
  const CardStations({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return Container(
      //   decoration: BoxDecoration(borderRadius: BorderRadius.all()),
      child: Card(
        elevation: 9,
        shadowColor: Colors.black,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stations.stationsName.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 20.sp),
                      ),
                      Image.asset(ImgPath.logoMap, width: 50.w)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue, // Set border color
                            width: 2.0, // Set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(100), // Set border radius
                        ),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Icon(
                            Icons.timelapse_rounded,
                            color: Colors.blue,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      onTap: () async {},
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue, // Set border color
                            width: 2.0, // Set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(100), // Set border radius
                        ),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Icon(
                            Icons.phone,
                            color: Colors.blue,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      onTap: () async {
                        String url = 'tel:0799665510';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue, // Set border color
                            width: 2.0, // Set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(100), // Set border radius
                        ),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Icon(
                            Icons.directions,
                            color: Colors.blue,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      onTap: () async {
                        String googleUrl =
                            'https://www.google.com/maps/search/?api=1&query=${stations.x},${stations.y}';
                        if (await canLaunchUrl(Uri.parse(googleUrl))) {
                          await launchUrl(Uri.parse(googleUrl));
                        } else {
                          throw 'Could not open the map.';
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
