class Result {
  String token;
  User user;

  Result({this.token, this.user});

  Result.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
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
  dynamic alternateNo;
  int wallet;
  int cityId;
  int locationId;
  dynamic areaId;
  dynamic pincode;
  String address;
  dynamic landmark;
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