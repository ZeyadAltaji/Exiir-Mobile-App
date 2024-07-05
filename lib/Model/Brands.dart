class Brands {
  int? brId;
  String? brName;
  String? brNameAr;
  String? brLogo;
  String? brOrigin;
  bool? brIsActive;
  String? brCreatedAt;
  int? brCreatedBy;

  Brands(
      {this.brId,
      this.brName,
      this.brNameAr,
      this.brLogo,
      this.brOrigin,
      this.brIsActive,
      this.brCreatedAt,
      this.brCreatedBy});

  Brands.fromJson(Map<String, dynamic> json) {
    brId = json['br_id'];
    brName = json['br_name'];
    brNameAr = json['br_name_ar'];
    brLogo = json['br_logo'];
    brOrigin = json['br_origin'];
    brIsActive = json['br_is_active'];
    brCreatedAt = json['br_created_at'];
    brCreatedBy = json['br_created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['br_id'] = this.brId;
    data['br_name'] = this.brName;
    data['br_name_ar'] = this.brNameAr;
    data['br_logo'] = this.brLogo;
    data['br_origin'] = this.brOrigin;
    data['br_is_active'] = this.brIsActive;
    data['br_created_at'] = this.brCreatedAt;
    data['br_created_by'] = this.brCreatedBy;
    return data;
  }
}
