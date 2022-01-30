class Coupons {
  List<CouponList> data;

  Coupons({this.data});

  Coupons.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new CouponList.fromJson(v));
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

class CouponList {
  int id;
  String code;
  dynamic userId;
  int offAmount;
  int offPercentage;
  int minimumCartValue;
  int frequency;
  dynamic createdBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  CouponList(
      {this.id,
      this.code,
      this.userId,
      this.offAmount,
      this.offPercentage,
      this.minimumCartValue,
      this.frequency,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CouponList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    offAmount = json['off_amount'];
    offPercentage = json['off_percentage'];
    minimumCartValue = json['minimum_cart_value'];
    frequency = json['frequency'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['user_id'] = this.userId;
    data['off_amount'] = this.offAmount;
    data['off_percentage'] = this.offPercentage;
    data['minimum_cart_value'] = this.minimumCartValue;
    data['frequency'] = this.frequency;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
