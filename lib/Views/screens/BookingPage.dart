import 'dart:convert';
import 'package:ExiirEV/Core/Constant/Environment.dart';
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
import 'package:table_calendar/table_calendar.dart';
import 'package:toasty_box/toast_service.dart';

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
  bool _timeSelected = false;
  bool _durationSelected = false;
  int? _selectedStation = 1;
  bool _isDurationAvailable = false;

  bool _isAvailable = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final BookingController controller = Get.put(BookingController());

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
        elevation: 0.0,
        backgroundColor: Appcolors.white,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Appcolors.Black, fontSize: 32),
            children: [
              TextSpan(
                text: translationController.getLanguage(93),
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
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _checkDateAndTimeIsAvailability();
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
            ],
          ),
        ),
        _isDurationAvailable == false
            ? SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  alignment: Alignment.center,
                ),
              )
            : SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
//duration
        _isDurationAvailable == false
            ? SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  alignment: Alignment.center,
                ),
              )
            : SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 100),
                          child: TextField(
                            controller: _hoursController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              labelText: translationController.Translate(
                                  'ساعات', 'Hours'),
                              hintText: 'H',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              int hours = int.tryParse(value) ?? 0;
                              if (hours > 1) {
                                _hoursController.text = '1';
                              } else if (hours < 0) {
                                _hoursController.text = '0';
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: TextField(
                            controller: _minutesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  2), // Limit to 2 digits (0-60)
                            ],
                            decoration: InputDecoration(
                              labelText: translationController.Translate(
                                  'دقائق', 'Minutes'),
                              hintText: 'MM',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              int minutes = int.tryParse(value) ?? 0;
                              if (minutes > 60) {
                                _minutesController.text = '60';
                              } else if (minutes < 0) {
                                _minutesController.text = '0';
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        _isDurationAvailable == false
            ? SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  alignment: Alignment.center,
                ),
              )
            : SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await _checkAllIsAvailability();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Failed to check availability: $e')),
                            );
                          }
                        },
                        child: Text(
                          translationController.getLanguage(100),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await _confirmBooking();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Failed to confirm booking: $e')),
                            );
                          }
                        },
                        child: Text(
                          translationController.getLanguage(101),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
      focusedDay: _focusedDay,
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      firstDay: DateTime.now().subtract(Duration(days: 365)),
      lastDay: DateTime.now().add(Duration(days: 365)),
      availableGestures: AvailableGestures.all,
      calendarFormat: _format,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      weekendDays: [DateTime.friday, DateTime.saturday],
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
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay ?? selectedDay;
          _timeSelected = false;
          _currentIndex = null;
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

  Future<void> _checkDateAndTimeIsAvailability() async {
    if (_selectedStation == null) {
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
      final response = await http.post(
        Uri.parse(
            '${Environment.baseUrl}ExiirManagementAPI/checkDateAndTimeIsAvailability'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'date': selectedDateTime.toIso8601String(),
          'hour': hour,
          'minute': minute,
          'stationId': _selectedStation!,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          _isDurationAvailable = jsonDecode(response.body)['available'];
        });
        if (_isDurationAvailable == true) {
          ToastService.showSuccessToast(
            context,
            message: translationController.Translate('تم التحقق', 'Verified'),
          );
        } else {
          ToastService.showWarningToast(
            context,
            message: translationController.Translate(
                'المدة او الوقت الذي تم اختياره يتعارض مع موعد اخر',
                'The duration or time chosen is inconsistent with another date'),
          );
        }
      } else {
        ToastService.showWarningToast(
          context,
          message:
              translationController.Translate('فشل في التحقق', 'Fail to check'),
        );
      }
    } catch (e) {
      ToastService.showErrorToast(
        context,
        message:
            translationController.Translate('فشل في التحقق', 'Fail to check'),
      );
    }
  }

  Future<void> _checkAllIsAvailability() async {
    if (_selectedStation == null ||
        _hoursController.text == '' ||
        _minutesController.text == '') {
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
            message: translationController.Translate('تم التحقق', 'Verified'),
          );
        } else {
          ToastService.showWarningToast(
            context,
            message: translationController.Translate(
                'المدة او الوقت الذي تم اختياره يتعارض مع موعد اخر',
                'The duration or time chosen is inconsistent with another date'),
          );
        }
      } else {
        ToastService.showWarningToast(
          context,
          message:
              translationController.Translate('فشل في التحقق', 'Fail to check'),
        );
      }
    } catch (e) {
      ToastService.showErrorToast(
        context,
        message:
            translationController.Translate('فشل في التحقق', 'Fail to check'),
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
      final response = await http.post(
        Uri.parse('${Environment.baseUrl}ExiirManagementAPI/confirmBooking'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'date': selectedDateTime.toIso8601String(),
          'hour': hour,
          'minute': minute,
          'duration': hours * 60 + minutes,
          'tripType': _selectedTrip.toString().split('.').last,
          'stationId': _selectedStation!,
        }),
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
          'booking': Booking.fromJson(responseData['booking']),
        });
      } else {
        ToastService.showWarningToast(
          context,
          message: translationController.Translate(
              'فشل في تأكيد الحجز', 'Failed to confirm booking'),
        );
      }
    } catch (e) {
      ToastService.showErrorToast(
        context,
        message: translationController.Translate(
            'فشل في تأكيد الحجز', 'Failed to confirm booking'),
      );
    }
  }
}
