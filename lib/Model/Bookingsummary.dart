class Bookingsummary {
  String? message;
  List<Bookings>? bookings;
  GetnameStation? getnameStation;

  Bookingsummary({this.message, this.bookings, this.getnameStation});

  Bookingsummary.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Bookings.fromJson(v));
      });
    }
    getnameStation = json['getnameStation'] != null
        ? new GetnameStation.fromJson(json['getnameStation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    if (this.getnameStation != null) {
      data['getnameStation'] = this.getnameStation!.toJson();
    }
    return data;
  }
}

class Bookings {
  int? bookingId;
  int? usUserId;
  String? bookingDate;
  String? endBookingDate;
  int? bookingType;
  String? bookingTime;
  int? duration;
  bool? isAvailable;
  int? stationId;
  int? carsType;
  int? brId;
  int? moId;
  int? veId;

  Bookings(
      {this.bookingId,
      this.usUserId,
      this.bookingDate,
      this.endBookingDate,
      this.bookingType,
      this.bookingTime,
      this.duration,
      this.isAvailable,
      this.stationId,
      this.carsType,
      this.brId,
      this.moId,
      this.veId});

  Bookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    usUserId = json['us_user_id'];
    bookingDate = json['bookingDate'];
    endBookingDate = json['endBookingDate'];
    bookingType = json['bookingType'];
    bookingTime = json['bookingTime'];
    duration = json['duration'];
    isAvailable = json['isAvailable'];
    stationId = json['stationId'];
    carsType = json['carsType'];
    brId = json['br_id'];
    moId = json['mo_id'];
    veId = json['ve_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['us_user_id'] = this.usUserId;
    data['bookingDate'] = this.bookingDate;
    data['endBookingDate'] = this.endBookingDate;
    data['bookingType'] = this.bookingType;
    data['bookingTime'] = this.bookingTime;
    data['duration'] = this.duration;
    data['isAvailable'] = this.isAvailable;
    data['stationId'] = this.stationId;
    data['carsType'] = this.carsType;
    data['br_id'] = this.brId;
    data['mo_id'] = this.moId;
    data['ve_id'] = this.veId;
    return data;
  }
}

class GetnameStation {
  int? csId;
  String? csNameAr;
  String? csName;
  String? csImagePath;
  String? csLangtitude;
  String? csLatitude;
  String? csAddress;
  String? csPhone;
  String? csEmail;
  bool? csIsActive;
  String? csCreatedAt;
  int? csCreatedBy;

  GetnameStation(
      {this.csId,
      this.csNameAr,
      this.csName,
      this.csImagePath,
      this.csLangtitude,
      this.csLatitude,
      this.csAddress,
      this.csPhone,
      this.csEmail,
      this.csIsActive,
      this.csCreatedAt,
      this.csCreatedBy});

  GetnameStation.fromJson(Map<String, dynamic> json) {
    csId = json['cs_id'];
    csNameAr = json['cs_name_ar'];
    csName = json['cs_name'];
    csImagePath = json['cs_image_path'];
    csLangtitude = json['cs_langtitude'];
    csLatitude = json['cs_latitude'];
    csAddress = json['cs_address'];
    csPhone = json['cs_phone'];
    csEmail = json['cs_email'];
    csIsActive = json['cs_is_active'];
    csCreatedAt = json['cs_created_at'];
    csCreatedBy = json['cs_created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cs_id'] = this.csId;
    data['cs_name_ar'] = this.csNameAr;
    data['cs_name'] = this.csName;
    data['cs_image_path'] = this.csImagePath;
    data['cs_langtitude'] = this.csLangtitude;
    data['cs_latitude'] = this.csLatitude;
    data['cs_address'] = this.csAddress;
    data['cs_phone'] = this.csPhone;
    data['cs_email'] = this.csEmail;
    data['cs_is_active'] = this.csIsActive;
    data['cs_created_at'] = this.csCreatedAt;
    data['cs_created_by'] = this.csCreatedBy;
    return data;
  }
}
