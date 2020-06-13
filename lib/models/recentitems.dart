class OntheWay {
  int count;
  String date;
  String code;

  OntheWay({this.count, this.date, this.code});

  OntheWay.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    date = json['date'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['date'] = this.date;
    data['code'] = this.code;
    return data;
  }
}
