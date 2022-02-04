// class Transactions {
//   List<TransactionData> data;

//   Transactions({this.data});

//   Transactions.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       // data = new List<TransactionData>();
//       data = [];
//       json['data'].forEach((v) {
//         data.add(new TransactionData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class TransactionData {
//   int id;
//   int userId;
//   dynamic amount;
//   String type;
//   dynamic about;
//   String createdAt;
//   String updatedAt;
//   String deletedAt;

//   User user;

//   TransactionData(
//       {this.id,
//       this.userId,
//       this.amount,
//       this.type,
//       this.about,
//       this.createdAt,
//       this.updatedAt,
//       this.deletedAt,
//       this.user});

//   TransactionData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     amount = json['amount'];
//     type = json['type'];
//     about = json['about'] ?? "";
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['amount'] = this.amount;
//     data['type'] = this.type;
//     data['about'] = this.about;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['deleted_at'] = this.deletedAt;
//     if (this.user != null) {
//       data['user'] = this.user.toJson();
//     }
//     return data;
//   }
// }

// class User {
//   int id;
//   String name;
//   String email;
//   String mobileNo;
//   String alternateNo;
//   int wallet;
//   int cityId;
//   int locationId;
//   dynamic areaId;
//   String pincode;
//   String address;
//   String landmark;
//   dynamic cardNo;
//   dynamic cardPin;
//   dynamic state;
//   String referralCode;
//   dynamic referredBy;
//   String createdAt;
//   String updatedAt;

//   User(
//       {this.id,
//       this.name,
//       this.email,
//       this.mobileNo,
//       this.alternateNo,
//       this.wallet,
//       this.cityId,
//       this.locationId,
//       this.cardNo,
//       this.cardPin,
//       this.areaId,
//       this.pincode,
//       this.address,
//       this.landmark,
//       this.state,
//       this.referralCode,
//       this.referredBy,
//       this.createdAt,
//       this.updatedAt});

//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     mobileNo = json['mobile_no'];
//     alternateNo = json['alternate_no'];
//     wallet = json['wallet'];
//     cityId = json['city_id'];
//     locationId = json['location_id'];
//     areaId = json['area_id'];
//     cardNo = json['card_no'];
//     cardPin = json['card_pin'];
//     pincode = json['pincode'];
//     address = json['address'];
//     landmark = json['landmark'];
//     state = json['state'];
//     referralCode = json['referral_code'];
//     referredBy = json['referred_by'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['mobile_no'] = this.mobileNo;
//     data['alternate_no'] = this.alternateNo;
//     data['wallet'] = this.wallet;
//     data['city_id'] = this.cityId;
//     data['location_id'] = this.locationId;
//     data['area_id'] = this.areaId;
//     data['pincode'] = this.pincode;
//     data['card_no'] = this.cardNo;
//     data['card_pin'] = this.cardPin;
//     data['address'] = this.address;
//     data['landmark'] = this.landmark;
//     data['state'] = this.state;
//     data['referral_code'] = this.referralCode;
//     data['referred_by'] = this.referredBy;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }


class Transactions {
  Transactions({
     this.data,
  });
  List<TransactionData> data;
  
  Transactions.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>TransactionData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class TransactionData {
  TransactionData({
     this.id,
     this.userId,
     this.amount,
     this.type,
     this.about,
     this.createdAt,
     this.updatedAt,
     this.deletedAt,
     this.user,
  });
    int id;
    int userId;
    dynamic amount;
    String type;
    dynamic about;
    String createdAt;
    String updatedAt;
    dynamic deletedAt;
    User user;
  
  TransactionData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    type = json['type'];
    about = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = null;
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['amount'] = amount;
    _data['type'] = type;
    _data['about'] = about;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
     this.id,
     this.name,
     this.email,
     this.mobileNo,
     this.alternateNo,
     this.wallet,
     this.subscriptionWallet,
     this.cityId,
     this.cardNo,
     this.cardPin,
     this.locationId,
     this.areaId,
     this.pincode,
     this.address,
     this.landmark,
     this.state,
     this.referralCode,
     this.referredBy,
     this.createdAt,
     this.updatedAt,
  });
    int id;
    String name;
    String email;
    String mobileNo;
    String alternateNo;
    double wallet;
    int subscriptionWallet;
    int cityId;
    dynamic cardNo;
    dynamic cardPin;
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
  
  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    alternateNo = json['alternate_no'];
    wallet = json['wallet'];
    subscriptionWallet = json['subscription_wallet'];
    cityId = json['city_id'];
    cardNo = null;
    cardPin = null;
    locationId = json['location_id'];
    areaId = null;
    pincode = json['pincode'];
    address = json['address'];
    landmark = json['landmark'];
    state = null;
    referralCode = json['referral_code'];
    referredBy = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['mobile_no'] = mobileNo;
    _data['alternate_no'] = alternateNo;
    _data['wallet'] = wallet;
    _data['subscription_wallet'] = subscriptionWallet;
    _data['city_id'] = cityId;
    _data['card_no'] = cardNo;
    _data['card_pin'] = cardPin;
    _data['location_id'] = locationId;
    _data['area_id'] = areaId;
    _data['pincode'] = pincode;
    _data['address'] = address;
    _data['landmark'] = landmark;
    _data['state'] = state;
    _data['referral_code'] = referralCode;
    _data['referred_by'] = referredBy;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}