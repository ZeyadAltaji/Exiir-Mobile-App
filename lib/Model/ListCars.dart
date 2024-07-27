class ListCars {
  int? userCar_id;

  int? us_user_id;
  int? mo_id;
  int? br_id;
  int? ve_id;

  String? br_name_ar;
  String? br_name;
  String? br_logo;
  String? ve_name;
  String? mo_name_ar;
  String? mo_name;

  ListCars(
      {this.userCar_id,this.us_user_id,
      this.mo_id,
      this.br_id,
      this.ve_id,
      this.br_name_ar,
      this.br_name,
      this.br_logo,
      this.ve_name,
      this.mo_name_ar,
      this.mo_name});

  ListCars.fromJson(Map<String, dynamic> json) {
    userCar_id = json['userCar_id'];

    us_user_id = json['us_user_id'];
    mo_id = json['mo_id'];
    br_id = json['br_id'];
    ve_id = json['ve_id'];

    br_name_ar = json['br_name_ar'];
    br_name = json['br_name'];
    br_logo = json['br_logo'];
    ve_name = json['ve_name'];
    mo_name_ar = json['mo_name_ar'];
    mo_name = json['mo_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userCar_id'] = this.userCar_id;
    data['us_user_id'] = this.us_user_id;
    data['mo_id'] = this.mo_id;
    data['br_name_ar'] = this.br_name_ar;
    data['br_name'] = this.br_name;
    data['br_logo'] = this.br_logo;
    data['ve_name'] = this.ve_name;
    data['mo_name_ar'] = this.mo_name_ar;
    data['mo_name'] = this.mo_name;
    return data;
  }
}
