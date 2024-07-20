class AppointmentTypes {
  int? atId;
  String? atDescription;
  bool? atIsActive;
  String? atCreatedAt;
  int? atCreatedBy;

  AppointmentTypes(
      {this.atId,
      this.atDescription,
      this.atIsActive,
      this.atCreatedAt,
      this.atCreatedBy});

  AppointmentTypes.fromJson(Map<String, dynamic> json) {
    atId = json['at_id'];
    atDescription = json['at_description'];
    atIsActive = json['at_is_active'];
    atCreatedAt = json['at_created_at'];
    atCreatedBy = json['at_created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['at_id'] = this.atId;
    data['at_description'] = this.atDescription;
    data['at_is_active'] = this.atIsActive;
    data['at_created_at'] = this.atCreatedAt;
    data['at_created_by'] = this.atCreatedBy;
    return data;
  }
}
