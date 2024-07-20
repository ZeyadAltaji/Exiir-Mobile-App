import 'package:ExiirEV/Controller/CarsController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Model/Booking.dart';
import 'package:ExiirEV/Model/ChargingStations.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum BookingType { Normal, VIP }

Map<BookingType, String> _bookingType = {
  BookingType.Normal: translationController.getLanguage(98),
  BookingType.VIP: translationController.getLanguage(99),
};
BookingType _selectedTrip = BookingType.Normal;
DateFormat dateFormat = DateFormat('yyyy-MM-dd');

class Bookingsummary extends StatelessWidget {
  const Bookingsummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TranslationController translationController =
        Get.put(TranslationController());
    final arguments = Get.arguments;
    if (arguments == null) {
      return const Scaffold(
        body: Center(
          child: Text('No data received'),
        ),
      );
    }
    final booking = arguments['booking'] as Booking;
    final station = arguments['station'] as ChargingStations;
    BookingType getBookingType(int bookingType) {
      switch (bookingType) {
        case 1:
          return BookingType.Normal;
        case 2:
          return BookingType.VIP;
        default:
          return BookingType.Normal;
      }
    }

    _selectedTrip = getBookingType(booking.BookingType);

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              style: const TextStyle(color: Appcolors.Black, fontSize: 32),
              children: [
                TextSpan(
                  text: translationController.getLanguage(102),
                ),
              ]),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: const [
                      BoxShadow(
                          color: Appcolors.black26,
                          offset: Offset(0, 6),
                          blurRadius: 6),
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_bookingType.length, (index) {
                    return buildBookingTypeSelector(
                        _bookingType.keys.elementAt(index));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: buildAirportSelector(
                  AirportInfo(
                    translationController.Translate(
                        station.csNameAr!, station.csName!),
                    translationController.getLanguage(106),
                  ),
                  FontAwesomeIcons.chargingStation,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: buildDateSelector(
                  // تاريخ بدء الحجز
                  translationController.getLanguage(104).trim(),
                  booking.BookingDate,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: buildDateSelector(
                  // تاريخ انتهاء الحجز

                  translationController.getLanguage(105).trim(),
                  booking.EndBookingDate ??
                      DateTime.now().add(Duration(days: 10)),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Appcolors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: buildtimeSelector(
                        translationController.getLanguage(108).trim(),
                        DateTime.now().add(Duration(minutes: booking.Duration)),
                        showTime: true,
                        timeLabel: convertDuration(booking.Duration).trim(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Appcolors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: buildTravelersView(
                          translationController.getLanguage(109).trim(),
                          booking.BookingTime!),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Appcolors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: buildTravelersView(
                          translationController.getLanguage(17),
                          station.csPhone!),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Appcolors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: buildTravelersView(
                          translationController.getLanguage(16),
                          station.csAddress!),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Appcolors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Appcolors.black26,
                          offset: Offset(0, 12),
                          blurRadius: 12,
                        ),
                      ],
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width * 2,
                          100,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Material(
                      color: Appcolors.blue,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 16,
                      child: InkWell(
                        onTap: () {
                          Get.offAllNamed(AppRoutes.HomePage);
                        },
                        splashColor: const Color.fromARGB(255, 69, 145, 206),
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text(
                            translationController.getLanguage(103),
                            style: GoogleFonts.overpass(
                              color: Appcolors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convertDuration(int durationInMinutes) {
    int hours = durationInMinutes ~/ 60;
    int minutes = durationInMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  Widget buildBookingTypeSelector(BookingType bookingType) {
    bool isSelected = _selectedTrip == bookingType;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 16, right: 16),
        backgroundColor: isSelected ? Appcolors.blue : Appcolors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {},
      child: Row(
        children: <Widget>[
          if (bookingType == BookingType.VIP)
            Icon(
              FontAwesomeIcons.crown,
              color: isSelected ? Appcolors.white : Appcolors.blue,
            ),
          const SizedBox(width: 15),
          Text(
            _bookingType[bookingType]!,
            style: TextStyle(
              color: isSelected ? Appcolors.white : Appcolors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAirportSelector(AirportInfo airportinfo, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              airportinfo.airportShortName,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
            Text(
              airportinfo.airportLongName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Icon(icon, color: Colors.black87),
      ],
    );
  }
}

Widget buildtimeSelector(String title, DateTime dateTime,
    {bool showTime = false, required String timeLabel}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: GoogleFonts.overpass(fontSize: 18, color: Appcolors.grey),
      ),
      if (showTime)
        Text(
          timeLabel,
          style: GoogleFonts.overpass(fontSize: 17),
        ),
    ],
  );
}

Widget buildBookingTypeSelector(BookingType bookingType) {
  bool isSelected = _selectedTrip == bookingType;

  return TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.only(left: 16, right: 16),
      backgroundColor: isSelected ? Appcolors.blue : Appcolors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    onPressed: () {},
    child: Row(
      children: <Widget>[
        if (bookingType == BookingType.VIP)
          Icon(
            FontAwesomeIcons.crown,
            color: isSelected ? Appcolors.white : Appcolors.blue,
          ),
        const SizedBox(width: 15),
        Text(
          _bookingType[bookingType]!,
          style: TextStyle(
            color: isSelected ? Appcolors.white : Appcolors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget buildTravelersView(String title, String value) {
  return Row(
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.overpass(fontSize: 18, color: Colors.grey),
          ),
          Text(
            value,
            style: GoogleFonts.overpass(fontSize: 17),
          )
        ],
      )
    ],
  );
}

// Widget buildDateSelector(String title, DateTime dateTime) {
//   String formattedDate = DateFormat('dd').format(dateTime);
//   String monthYear = DateFormat('MMM yyyy').format(dateTime);
//   String weekday = DateFormat('EEEE').format(dateTime);
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: <Widget>[
//       Text(
//         title,
//         style: GoogleFonts.overpass(fontSize: 18, color: Colors.grey),
//       ),
//       Row(
//         children: <Widget>[
//           Text(
//             formattedDate,
//             style: GoogleFonts.overpass(fontSize: 48),
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 monthYear,
//                 style: GoogleFonts.overpass(fontSize: 16),
//               ),
//               Text(
//                 weekday,
//                 style: GoogleFonts.overpass(fontSize: 16, color: Colors.grey),
//               ),
//             ],
//           )
//         ],
//       )
//     ],
//   );
// }

  Widget buildDateSelector(String label, DateTime date) {
     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
             label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            Text(
              "${date.day}/${date.month}/${date.year}",
              style: const TextStyle(
                fontSize: 18,
               ),
            ),
          ],
        ),
       
      ],
    );
  
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     Text(label,  style: GoogleFonts.overpass(fontSize: 18, color: Colors.grey),),
    //     Text(
    //       "${date.day}/${date.month}/${date.year}",
    //       style: GoogleFonts.overpass(fontSize: 16),
    //     ),
    //   ],
    // );
  }

class AirportInfo {
  final String airportShortName;
  final String airportLongName;

  AirportInfo(this.airportLongName, this.airportShortName);
}
