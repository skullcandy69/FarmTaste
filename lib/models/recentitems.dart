class OntheWay {
  int count;
  String date;
  List<Codes> codes;

  OntheWay({this.count, this.date, this.codes});

  OntheWay.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    date = json['date'];
    if (json['codes'] != null) {
      codes = new List<Codes>();
      json['codes'].forEach((v) {
        codes.add(new Codes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['date'] = this.date;
    if (this.codes != null) {
      data['codes'] = this.codes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Codes {
  int orderId;
  String code;

  Codes({this.orderId, this.code});

  Codes.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['code'] = this.code;
    return data;
  }
}
