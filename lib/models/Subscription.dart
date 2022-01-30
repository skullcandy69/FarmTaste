import 'package:grocery/models/user_model.dart';

class Subscriptions {
  List<SubscriptionData> data;

  Subscriptions({this.data});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // data = new List<SubscriptionData>();
      data = [];
      json['data'].forEach((v) {
        data.add(new SubscriptionData.fromJson(v));
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

class SubscriptionData {
  int id;
  int userId;
  Product product;
  String startDate;
  String endDate;
  String subscriptionType;
  int noOfDays;
  dynamic baseAmount;
  dynamic amount;
  dynamic deliveryCharge;
  dynamic discount;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  User user;

  SubscriptionData(
      {this.id,
      this.userId,
      this.product,
      this.startDate,
      this.endDate,
      this.subscriptionType,
      this.noOfDays,
      this.baseAmount,
      this.amount,
      this.deliveryCharge,
      this.discount,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    startDate = json['start_date'];
    endDate = json['end_date'];
    subscriptionType = json['subscription_type'];
    noOfDays = json['no_of_days'];
    baseAmount = json['base_amount'];
    amount = json['amount'];
    deliveryCharge = json['delivery_charge'];
    discount = json['discount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['subscription_type'] = this.subscriptionType;
    data['no_of_days'] = this.noOfDays;
    data['base_amount'] = this.baseAmount;
    data['amount'] = this.amount;
    data['delivery_charge'] = this.deliveryCharge;
    data['discount'] = this.discount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Product {
  int productId;
  String title;
  dynamic baseRate;
  dynamic rate;
  int noOfUnits;
  String imageUrl;

  Product(
      {this.productId,
      this.title,
      this.baseRate,
      this.rate,
      this.noOfUnits,
      this.imageUrl});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    title = json['title'];
    baseRate = json['base_rate'];
    rate = json['rate'];
    noOfUnits = json['no_of_units'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['title'] = this.title;
    data['base_rate'] = this.baseRate;
    data['rate'] = this.rate;
    data['no_of_units'] = this.noOfUnits;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

