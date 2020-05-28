class History {
  List<HistoryData> data;

  History({this.data});

  History.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<HistoryData>();
      json['data'].forEach((v) {
        data.add(new HistoryData.fromJson(v));
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

class HistoryData {
  int id;
  int orderId;
  int userId;
  String deliveryAddress;
  List<Products> products;
  dynamic baseAmount;
  dynamic amount;
  dynamic deliveryCharge;
  dynamic discount;
  int employeeId;
  String paymentMode;
  String paymentStatus;
  String deliveryDate;
  String orderStatus;
  int transactionId;
  String transactedAt;
  String createdAt;
  String updatedAt;
  String deletedAt;
  User user;

  HistoryData(
      {this.id,
      this.orderId,
      this.userId,
      this.deliveryAddress,
      this.products,
      this.baseAmount,
      this.amount,
      this.deliveryCharge,
      this.discount,
      this.employeeId,
      this.paymentMode,
      this.paymentStatus,
      this.deliveryDate,
      this.orderStatus,
      this.transactionId,
      this.transactedAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user});

  HistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    deliveryAddress = json['delivery_address'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    baseAmount = json['base_amount'];
    amount = json['amount'];
    deliveryCharge = json['delivery_charge'];
    discount = json['discount'];
    employeeId = json['employee_id'];
    paymentMode = json['payment_mode'];
    paymentStatus = json['payment_status'];
    deliveryDate = json['delivery_date'];
    orderStatus = json['order_status'];
    transactionId = json['transaction_id'];
    transactedAt = json['transacted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['delivery_address'] = this.deliveryAddress;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['base_amount'] = this.baseAmount;
    data['amount'] = this.amount;
    data['delivery_charge'] = this.deliveryCharge;
    data['discount'] = this.discount;
    data['employee_id'] = this.employeeId;
    data['payment_mode'] = this.paymentMode;
    data['payment_status'] = this.paymentStatus;
    data['delivery_date'] = this.deliveryDate;
    data['order_status'] = this.orderStatus;
    data['transaction_id'] = this.transactionId;
    data['transacted_at'] = this.transactedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Products {
  int productId;
  int noOfUnits;
  dynamic rate;
  String title;
  String imageUrl;

  Products(
      {this.productId, this.noOfUnits, this.rate, this.title, this.imageUrl});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    noOfUnits = json['no_of_units'];
    rate = json['rate'];
    title = json['title'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['no_of_units'] = this.noOfUnits;
    data['rate'] = this.rate;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String mobileNo;
  dynamic alternateNo;
  dynamic wallet;
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
