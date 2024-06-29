class Message {
  final int? Id;
  final String? MsgAr;
  final String? MsgEn;

  Message({
    this.Id,
    this.MsgAr,
    this.MsgEn,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      Id: json['Id'],
      MsgAr: json['MsgAr'],
      MsgEn: json['MsgEn'],
    );
  }
}
