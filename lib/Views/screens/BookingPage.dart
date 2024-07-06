import 'dart:convert';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:http/http.dart' as http;

import 'package:ExiirEV/Controller/BookingController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Model/Booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

final TranslationController translationController =
    Get.put(TranslationController());

// ignore: constant_identifier_names
enum TripType { Normal, VIP }

Map<TripType, String> _tripTypes = {
  TripType.Normal: translationController.getLanguage(98),
  TripType.VIP: translationController.getLanguage(99),
};

class _BookingPageState extends State<BookingPage> {
  TripType _selectedTrip = TripType.Normal;
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  int? _selectedDurationIndex;
  bool _durationSelected = false;
  int? _selectedStation = 1;
  bool _isAvailable = false;
  final List<String> _durations = [
    '15 minutes',
    '30 minutes',
    '1 hour',
    '2 hours',
    '3 hours',
    '4 hours',
  ];
  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.put(BookingController());
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Appcolors.white,
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Appcolors.Black, fontSize: 32),
              children: [
                TextSpan(
                  text: translationController.getLanguage(93),
                  style: const TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Appcolors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Appcolors.black26,
                        offset: Offset(0, 6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
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
        body: CustomScrollView(slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      translationController.getLanguage(94),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    alignment: Alignment.center,
                    child: Text(
                      translationController.GetMessages(9),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.grey,
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Appcolors.transparent,
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            _timeSelected = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Appcolors.white
                                  : Appcolors.Black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: _currentIndex == index
                                ? Appcolors.kPrimaryColor
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 9}:00 ${index + 9 > 11 ? translationController.getLanguage(95) : translationController.getLanguage(96)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _currentIndex == index
                                  ? Appcolors.white
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.5),
                ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Center(
                child: Text(
                  translationController.getLanguage(97),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return InkWell(
                  splashColor: Appcolors.transparent,
                  onTap: () {
                    setState(() {
                      _selectedDurationIndex = index;
                      _durationSelected = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedDurationIndex == index
                            ? Appcolors.white
                            : Appcolors.Black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _selectedDurationIndex == index
                          ? Appcolors.kPrimaryColor
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _durations[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selectedDurationIndex == index
                            ? Appcolors.white
                            : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: _durations.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (!_dateSelected ||
                        !_timeSelected ||
                        !_durationSelected ||
                        _selectedStation == null) {
                      return;
                    }

                    try {
                      await _checkAvailability();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to check availability: $e')),
                      );
                    }
                  },
                  child: Text(
                    translationController.getLanguage(100),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!_dateSelected ||
                        !_timeSelected ||
                        !_durationSelected ||
                        _selectedStation == null ||
                        !_isAvailable) {
                      return;
                    }

                    try {
                      await _confirmBooking();
                    } catch (e) {}
                  },
                  child: Text(
                    translationController.getLanguage(101),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )),
        ]));
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      calendarFormat: _format,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay ?? selectedDay;
          _dateSelected = true;

          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      },
    );
  }

  Widget buildTripTypeSelector(TripType tripType) {
    bool isVip = tripType == TripType.VIP;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 16, right: 16),
        backgroundColor:
            _selectedTrip == tripType ? Appcolors.blue : Appcolors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedTrip = tripType;
        });
      },
      child: Row(
        children: <Widget>[
          if (isVip)
            Icon(
              FontAwesomeIcons.crown,
              color:
                  _selectedTrip == tripType ? Appcolors.white : Appcolors.blue,
            ),
          const SizedBox(width: 15),
          Text(
            _tripTypes[tripType]!,
            style: TextStyle(
              color:
                  _selectedTrip == tripType ? Appcolors.white : Appcolors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAvailability() async {
    if (!_dateSelected ||
        !_timeSelected ||
        !_durationSelected ||
        _selectedStation == null) {
      return;
    }

    try {
      DateTime selectedDateTime = DateTime(_selectedDay.year,
          _selectedDay.month, _selectedDay.day, _currentIndex! + 9);

      final response = await http.post(
        Uri.parse('${Environment.baseUrl}ExiirManagementAPI/checkAvailability'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'date': selectedDateTime.toIso8601String(),
          'time': _currentIndex! + 9,
          'duration': _selectedDurationIndex! + 1,
          'stationId': _selectedStation!,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isAvailable = jsonDecode(response.body)['available'];
        });
      } else {
        throw Exception('Failed to check availability');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check availability: $e')),
      );
    }
  }

  Future<void> _confirmBooking() async {
    if (!_dateSelected ||
        !_timeSelected ||
        !_durationSelected ||
        _selectedStation == null ||
        !_isAvailable) {
      return;
    }

    try {
      DateTime selectedDateTime = DateTime(_selectedDay.year,
          _selectedDay.month, _selectedDay.day, _currentIndex! + 9);

      int durationInHours = (_selectedDurationIndex! + 1) * 15;
      final response = await http.post(
        Uri.parse('${Environment.baseUrl}ExiirManagementAPI/confirmBooking'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'date': selectedDateTime.toIso8601String(),
          'timeSlot': _currentIndex! + 9,
          'duration': durationInHours,
          'tripType': _selectedTrip.toString().split('.').last,
          'stationId': _selectedStation!,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isAvailable =
              false;  
        });
        Get.snackbar(
         translationController.GetMessages(10),
           translationController.GetMessages(11),
          duration:const Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Failed to confirm booking');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm booking: $e')),
      );
    }
  }
}
