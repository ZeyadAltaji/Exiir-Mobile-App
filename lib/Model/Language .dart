class Language {
  final int? Id;
  final String? LangDescAr;
  final String? LangDescEn;
 

  Language({
    this.Id,
    this.LangDescAr,
    this.LangDescEn,
 
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      Id: json['Id'],
      LangDescAr: json['LangDescAr'],
      LangDescEn: json['LangDescEn'],
 
    );
  }
}