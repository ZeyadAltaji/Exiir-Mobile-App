import 'dart:convert';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Model/ChargingStations.dart';
import 'package:ExiirEV/Views/screens/Bookingsummary.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:ExiirEV/Controller/BookingController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Model/Booking.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toasty_box/toast_service.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

final TranslationController translationController =
    Get.put(TranslationController());
final BookingController bookingController = Get.put(BookingController());

// ignore: constant_identifier_names
enum BookingType { Normal, VIP }

Map<BookingType, String> _bookingType = {
  BookingType.Normal: translationController.getLanguage(98),
  BookingType.VIP: translationController.getLanguage(99),
};

class _BookingPageState extends State<BookingPage> {
  BookingType _selectedTrip = BookingType.Normal;
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int? _currentIndex;
  bool _timeSelected = false;
  int? _selectedStation = 1;
  bool _isDurationAvailable = false;
  List<DateTime> _selectedDays = [];
  bool _showHoursField = true; // Show hours field by default

  bool _isAvailable = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final BookingController controller = Get.put(BookingController());
  final stationId = Get.parameters['stationId'];
  final type = Get.parameters['type'];
  final BrId = Get.parameters['BrandId'];
  final moid = Get.parameters['ModelId'];
  final veid = Get.parameters['VersionsId'];

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.white,
        title: Text(
          textAlign: TextAlign.center,
          translationController.getLanguage(93),
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
      body: Container(
          child: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              _tableCalendar(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                child: Center(),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Text(
                translationController.getLanguage(94),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // time
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    cancelText: translationController.getLanguage(10),
                    confirmText: translationController.getLanguage(88),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedTime = pickedTime;
                      _timeSelected = true;
                    });
                  }
                },
                child: Text(
                  _timeSelected
                      ? _selectedTime.format(context)
                      : _selectedTime.format(context),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: _showHoursField == true
                          ? TextField(
                              controller: _hoursController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    translationController.getLanguage(118),
                                hintText: 'H',
                              ),
                              onChanged: (value) {
                                int hours = int.tryParse(value) ?? 0;
                                if (hours > 5) {
                                  _hoursController.text = '5';
                                } else if (hours < 0) {
                                  _hoursController.text = '0';
                                }
                              },
                            )
                          : TextField(
                              controller: _minutesController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    2), // Limit to 2 digits (0-60)
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    translationController.getLanguage(119),
                                hintText: 'MM',
                              ),
                              onChanged: (value) {
                                int minutes = int.tryParse(value) ?? 0;
                                if (minutes > 60) {
                                  _minutesController.text = '60';
                                } else if (minutes < 0) {
                                  _minutesController.text = '0';
                                }
                              },
                            )),
                ),
                SizedBox(
                  width: 7.w,
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showHoursField = true;
                          _hoursController.clear();
                        });
                      },
                      child: Text(translationController.getLanguage(118)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showHoursField = false;
                          _minutesController.clear();
                        });
                      },
                      child: Text(translationController.getLanguage(119)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    try {
                      await _checkAllIsAvailability();
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
                SizedBox(
                  height: 1.h,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    try {
                      await _confirmBooking();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to confirm booking: $e')),
                      );
                    }
                  },
                  child: Text(
                    translationController.getLanguage(101),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ])),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      locale: "en_US",
      rowHeight: 43,
      availableGestures: AvailableGestures.all,
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      focusedDay: _focusedDay,
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(Duration(days: 365)),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Appcolors.blue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Color.fromARGB(255, 116, 187, 245),
          shape: BoxShape.circle,
        ),
      ),
      calendarFormat: _format,
      selectedDayPredicate: (day) => _selectedDays.contains(day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (_selectedTrip == BookingType.Normal) {
            _selectedDays = [selectedDay];
            _selectedDay = DateTime.now();
            _focusedDay = DateTime.now();
          } else {
            if (_selectedDays.contains(selectedDay)) {
              _selectedDays.remove(selectedDay);
            } else {
              _selectedDays.add(selectedDay);
            }
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          }
          _timeSelected = false;
        });
      },
      onFormatChanged: (format) {
        if (_format != format) {
          setState(() {
            _format = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  Widget buildBookingTypeSelector(BookingType bookingType) {
    bool isVip = bookingType == BookingType.VIP;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 16, right: 16),
        backgroundColor:
            _selectedTrip == bookingType ? Appcolors.blue : Appcolors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedTrip = bookingType;
        });
      },
      child: Row(
        children: <Widget>[
          if (isVip)
            Icon(
              FontAwesomeIcons.crown,
              color: _selectedTrip == bookingType
                  ? Appcolors.white
                  : Appcolors.blue,
            ),
          const SizedBox(width: 15),
          Text(
            _bookingType[bookingType]!,
            style: TextStyle(
              color: _selectedTrip == bookingType
                  ? Appcolors.white
                  : Appcolors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAllIsAvailability() async {
    if (_selectedStation == null ||
        (_hoursController.text != '' && _minutesController.text == '') &&
            _hoursController.text == '' &&
            _minutesController.text != '') {
      ToastService.showWarningToast(
        context,
        message: translationController.GetMessages(16),
      );
      return;
    }

    try {
      DateTime selectedDateTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      int hour = _selectedTime.hourOfPeriod;
      int minute = _selectedTime.minute;
      int hours = int.tryParse(_hoursController.text) ?? 0;
      int minutes = int.tryParse(_minutesController.text) ?? 0;
      final response = await http.post(
        Uri.parse('${Environment.baseUrl}ExiirManagementAPI/checkAvailability'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'date': selectedDateTime.toIso8601String(),
          'hour': hour,
          'minute': minute,
          'duration': hours * 60 + minutes,
          'stationId': _selectedStation!,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isAvailable = jsonDecode(response.body)['available'];
        });
        if (_isAvailable == true) {
          ToastService.showSuccessToast(
            context,
            message: translationController.getLanguage(120),
          );
        } else {
          ToastService.showWarningToast(
            context,
            message: translationController.GetMessages(17),
          );
        }
      } else {
        ToastService.showWarningToast(
          context,
          message: translationController.GetMessages(18),
        );
      }
    } catch (e) {
      ToastService.showErrorToast(
        context,
        message: translationController.GetMessages(18),
      );
    }
  }

  Future<void> _confirmBooking() async {
    if (!_isAvailable) {
      return;
    }
    try {
      DateTime selectedDateTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      int hour = _selectedTime.hourOfPeriod;
      int minute = _selectedTime.minute;
      int hours = int.tryParse(_hoursController.text) ?? 0;
      int minutes = int.tryParse(_minutesController.text) ?? 0;
      List<Map<String, dynamic>> bookingRequests = [];

      final preferences = await SharedPreferences.getInstance();
      int durationInMinutes =
          _showHoursField ? (hours * 60 + minutes) : minutes;
      var UserId = preferences.getString('UserId');
      if (_selectedTrip == BookingType.Normal) {
        selectedDateTime = DateTime(
          _selectedDay.year,
          _selectedDay.month,
          _selectedDay.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
        bookingRequests.add({
          'date': selectedDateTime.toIso8601String(),
          'hour': hour,
          'minute': minute,
          'duration': durationInMinutes,
          'BookingType':
              _selectedTrip.toString().split('.').last == 'Normal' ? 1 : 2,
          'stationId': stationId!,
          'type': type!,
          'br_id': BrId!,
          'mo_id': moid!,
          've_id': veid!,
          'us_user_id': UserId!,
        });
      } else {
        for (var date in _selectedDays) {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            _selectedTime.hour,
            _selectedTime.minute,
          );
          bookingRequests.add({
            'date': selectedDateTime.toIso8601String(),
            'hour': hour,
            'minute': minute,
            'duration': durationInMinutes,
            'BookingType':
                _selectedTrip.toString().split('.').last == 'Normal' ? 1 : 2,
            'stationId': stationId!,
            'type': type!,
            'br_id': BrId!,
            'mo_id': moid!,
            've_id': veid!,
            'us_user_id': UserId!,
          });
        }
      }
      final response = await http.post(
        Uri.parse('${Environment.baseUrl}ExiirManagementAPI/confirmBooking'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bookingRequests),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isAvailable = false;
        });
        ToastService.showSuccessToast(
          context,
          message: translationController.GetMessages(11),
        );

        var responseData = jsonDecode(response.body);

        Get.to(() => Bookingsummary(), arguments: {
          'station': ChargingStations.fromJson(responseData['getnameStation']),
          'booking': Booking.fromJson(responseData['bookings']),
        });
      } else {
        ToastService.showWarningToast(
          context,
          message: translationController.GetMessages(19),
        );
      }
    } catch (e) {
      ToastService.showErrorToast(
        context,
        message: translationController.GetMessages(19),
      );
    }
  }
}
