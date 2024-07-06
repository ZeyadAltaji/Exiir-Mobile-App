class Booking {
  int? BookingId;
  DateTime BookingDate;
  String TripType;
  int BookingTime;
  int Duration;
  bool IsAvailable;
  int StationId;

  Booking({
     this.BookingId,
    required this.BookingDate,
    required this.TripType,
    required this.BookingTime,
    required this.Duration,
    required this.IsAvailable,
    required this.StationId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      BookingId: json['bookingId'],
      BookingDate: DateTime.parse(json['bookingDate']),
      TripType: json['tripType'],
      BookingTime: json['bookingTime'],
      Duration: json['duration'],
      IsAvailable: json['isAvailable'],
      StationId: json['stationId'],
    );
  }

  // To convert a Booking to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': BookingId,
      'bookingDate': BookingDate.toIso8601String(),
      'tripType': TripType,
      'bookingTime': BookingTime,
      'duration': Duration,
      'isAvailable': IsAvailable,
      'stationId': StationId,
    };
  }
}
