class Booking {
  int? BookingId;
  DateTime BookingDate;
  DateTime? EndBookingDate;
  int BookingType;
  String BookingTime;
  int Duration;
  bool IsAvailable;
  int StationId;
  int CarsType;
  int br_id;
  int mo_id;
  int? ve_id;
  int? us_user_id;

  Booking({
    this.BookingId,
    required this.BookingDate,
    this.EndBookingDate,
    required this.BookingType,
    required this.BookingTime,
    required this.Duration,
    required this.IsAvailable,
    required this.StationId,
    required this.CarsType,
    required this.br_id,
    required this.mo_id,
    this.ve_id,
    this.us_user_id,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      BookingId: json['bookingId'],
      BookingDate: DateTime.parse(json['bookingDate']),
      EndBookingDate: DateTime.parse(json['endBookingDate']),
      BookingType: json['bookingType'],
      BookingTime: json['bookingTime'],
      Duration: json['duration'],
      IsAvailable: json['isAvailable'],
      StationId: json['stationId'],
      CarsType: json['carsType'],
      br_id: json['br_id'],
      mo_id: json['mo_id'],
      ve_id: json['ve_id'],
      us_user_id: json['us_user_id'],
    );
  }

  // To convert a Booking to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': BookingId,
      'bookingDate': BookingDate.toIso8601String(),
      'endBookingDate': EndBookingDate!.toIso8601String(),
      'bookingType': BookingType,
      'bookingTime': BookingTime,
      'duration': Duration,
      'isAvailable': IsAvailable,
      'stationId': StationId,
      'carsType': CarsType,
      'br_id': br_id,
      'mo_id': mo_id,
      've_id': ve_id,
      'us_user_id': us_user_id,
    };
  }
}
