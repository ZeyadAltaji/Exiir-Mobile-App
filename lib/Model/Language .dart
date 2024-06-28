class Language {
  int? id;
  String? langDescAr;
  String? langDescEn;

  Language({this.id, this.langDescAr, this.langDescEn});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    langDescAr = json['langDescAr'];
    langDescEn = json['langDescEn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['langDescAr'] = this.langDescAr;
    data['langDescEn'] = this.langDescEn;
    return data;
  }
}