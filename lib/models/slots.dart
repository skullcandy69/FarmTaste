class Slots {
  List<SlotData> data;

  Slots({this.data});

  Slots.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // data = new List<SlotData>();
      data = [];
      json['data'].forEach((v) {
        data.add(new SlotData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotData {
  int id;
  String startTime;
  String endTime;
  bool isActive;
  String createdAt;
  String updatedAt;

  SlotData(
      {this.id,
      this.startTime,
      this.endTime,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  SlotData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['is_active'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
