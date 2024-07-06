class Versions {
  int? veId;
  int? veBrandId;
  int? veModelId;
  String? veName;
  bool? veIsActive;
  String? veCreatedAt;
  int? veCreatedBy;

  Versions(
      {this.veId,
      this.veBrandId,
      this.veModelId,
      this.veName,
      this.veIsActive,
      this.veCreatedAt,
      this.veCreatedBy});

  Versions.fromJson(Map<String, dynamic> json) {
    veId = json['ve_id'];
    veBrandId = json['ve_brandId'];
    veModelId = json['ve_modelId'];
    veName = json['ve_name'];
    veIsActive = json['ve_is_active'];
    veCreatedAt = json['ve_created_at'];
    veCreatedBy = json['ve_created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ve_id'] = this.veId;
    data['ve_brandId'] = this.veBrandId;
    data['ve_modelId'] = this.veModelId;
    data['ve_name'] = this.veName;
    data['ve_is_active'] = this.veIsActive;
    data['ve_created_at'] = this.veCreatedAt;
    data['ve_created_by'] = this.veCreatedBy;
    return data;
  }
}
