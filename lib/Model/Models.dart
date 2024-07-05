class Models {
  int? moId;
  String? moNameAr;
  String? moName;
  Null? moLogo;
  int? moBrandId;
  bool? moIsActive;
  String? moCreatedAt;
  int? moCreatedBy;

  Models(
      {this.moId,
      this.moNameAr,
      this.moName,
      this.moLogo,
      this.moBrandId,
      this.moIsActive,
      this.moCreatedAt,
      this.moCreatedBy});

  Models.fromJson(Map<String, dynamic> json) {
    moId = json['mo_id'];
    moNameAr = json['mo_name_ar'];
    moName = json['mo_name'];
    moLogo = json['mo_logo'];
    moBrandId = json['mo_brandId'];
    moIsActive = json['mo_is_active'];
    moCreatedAt = json['mo_created_at'];
    moCreatedBy = json['mo_created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mo_id'] = this.moId;
    data['mo_name_ar'] = this.moNameAr;
    data['mo_name'] = this.moName;
    data['mo_logo'] = this.moLogo;
    data['mo_brandId'] = this.moBrandId;
    data['mo_is_active'] = this.moIsActive;
    data['mo_created_at'] = this.moCreatedAt;
    data['mo_created_by'] = this.moCreatedBy;
    return data;
  }
}
