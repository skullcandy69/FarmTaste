class Transactions {
  List<TransactionData> data;

  Transactions({this.data});

  Transactions.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // data = new List<TransactionData>();
      data = [];
      json['data'].forEach((v) {
        data.add(new TransactionData.fromJson(v));
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

class TransactionData {
  int id;
  int userId;
  dynamic amount;
  String type;
  String createdAt;
  String updatedAt;
  String deletedAt;
  User user;

  TransactionData(
      {this.id,
      this.userId,
      this.amount,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String mobileNo;
  String alternateNo;
  int wallet;
  int cityId;
  int locationId;
  dynamic areaId;
  String pincode;
  String address;
  String landmark;
  dynamic state;
  String referralCode;
  dynamic referredBy;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
      this.name,
      this.email,
      this.mobileNo,
      this.alternateNo,
      this.wallet,
      this.cityId,
      this.locationId,
      this.areaId,
      this.pincode,
      this.address,
      this.landmark,
      this.state,
      this.referralCode,
      this.referredBy,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    alternateNo = json['alternate_no'];
    wallet = json['wallet'];
    cityId = json['city_id'];
    locationId = json['location_id'];
    areaId = json['area_id'];
    pincode = json['pincode'];
    address = json['address'];
    landmark = json['landmark'];
    state = json['state'];
    referralCode = json['referral_code'];
    referredBy = json['referred_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['alternate_no'] = this.alternateNo;
    data['wallet'] = this.wallet;
    data['city_id'] = this.cityId;
    data['location_id'] = this.locationId;
    data['area_id'] = this.areaId;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['state'] = this.state;
    data['referral_code'] = this.referralCode;
    data['referred_by'] = this.referredBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
