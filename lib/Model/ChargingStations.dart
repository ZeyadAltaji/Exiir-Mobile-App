class ChargingStations {
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
 
  ChargingStations(
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
      this.csCreatedBy,
   });

  ChargingStations.fromJson(Map<String, dynamic> json) {
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
