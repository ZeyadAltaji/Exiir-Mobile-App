import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Model/Booking.dart';
import 'package:ExiirEV/Model/ChargingStations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Bookingsummary extends StatefulWidget {
  const Bookingsummary({super.key});

  @override
  _BookingsummaryState createState() => _BookingsummaryState();
}

final TranslationController translationController =
    Get.put(TranslationController());

enum TripType { Normal, VIP }

TripType getTripType(String tripType) {
  switch (tripType) {
    case 'Normal':
      return TripType.Normal;
    case 'VIP':
      return TripType.VIP;
    default:
      return TripType.Normal;
  }
}

Map<String, int> durationMapping = {
  '15 minutes': 15,
  '30 minutes': 30,
  '1 hour': 60,
  '2 hours': 120,
  '3 hours': 180,
  '4 hours': 240,
};
String convertDuration(int minutes) {
  String durationText = '';
  durationMapping.forEach((key, value) {
    if (value == minutes) {
      durationText = key;
    }
  });
  return durationText;
}

Map<TripType, String> _tripTypes = {
  TripType.Normal: translationController.getLanguage(98),
  TripType.VIP: translationController.getLanguage(99),
};

class _BookingsummaryState extends State<Bookingsummary> {
  TripType _selectedTrip = TripType.Normal;

  @override
  Widget build(BuildContext context) {
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
    _selectedTrip = getTripType(booking.TripType);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Appcolors.white,
        title: RichText(
          text: TextSpan(
              style: const TextStyle(color: Appcolors.Black, fontSize: 32),
              children: [
                TextSpan(
                  text: translationController.getLanguage(102),
                  style: GoogleFonts.overpass(fontWeight: FontWeight.w200),
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
                  children: List.generate(_tripTypes.length, (index) {
                    return buildTripTypeSelector(
                        _tripTypes.keys.elementAt(index));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
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
              child: buildDateTimebookingSelector(
                translationController.getLanguage(104).trim(),
                booking.BookingDate,
                FontAwesomeIcons.calendarAlt,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Appcolors.white,
                padding: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: buildDateTimebookingSelector(
                translationController.getLanguage(105).trim(),
                booking.EndBookingDate!,
                FontAwesomeIcons.calendarAlt,
              ),
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
                    child: buildDateSelector(
                      translationController.getLanguage(108),
                      DateTime.now().add(Duration(hours: booking.Duration)),
                      showTime: true,
                      timeLabel: convertDuration(booking.Duration),
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
                      child: buildDateSelector(
                        translationController.getLanguage(109).trim(),
                        DateTime.now()
                            .add(Duration(hours: booking.BookingTime)),
                        showTime: true,
                        timeLabel:
                            "${booking.BookingTime.toString().padLeft(2, '0')}:00 ${booking.BookingTime > 11 ? translationController.getLanguage(95) : translationController.getLanguage(96)}",
                      )),
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

                        Get.offNamed(AppRoutes.HomePage);
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
    );
  }

  Widget buildDateSelector(String title, DateTime dateTime,
      {bool showTime = false, required String timeLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.overpass(fontSize: 18, color: Appcolors.grey),
        ),
        if (showTime)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              timeLabel,
              style: GoogleFonts.overpass(fontSize: 17, color: Appcolors.Black),
            ),
          ),
      ],
    );
  }

  Widget buildDateTimebookingSelector(
      String title, DateTime dateTime, IconData iconData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              iconData,
              size: 19,
              color: Appcolors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.overpass(fontSize: 18, color: Appcolors.grey),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              dateTime.day.toString().padLeft(2, '0'),
              style: GoogleFonts.overpass(fontSize: 48),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat.MMM().format(dateTime),
                  style: GoogleFonts.overpass(fontSize: 16),
                ),
                Text(
                  DateFormat.EEEE().format(dateTime),
                  style:
                      GoogleFonts.overpass(fontSize: 16, color: Appcolors.grey),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget buildTripTypeSelector(TripType tripType) {
    bool isSelected = _selectedTrip == tripType;

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
          if (tripType == TripType.VIP)
            Icon(
              FontAwesomeIcons.crown,
              color: isSelected ? Appcolors.white : Appcolors.blue,
            ),
          const SizedBox(width: 15),
          Text(
            _tripTypes[tripType]!,
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

class AirportInfo {
  final String airportShortName;
  final String airportLongName;

  AirportInfo(this.airportLongName, this.airportShortName);
}
