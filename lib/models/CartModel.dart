import 'package:flutter/material.dart';
import 'package:grocery/models/products.dart';
import 'dart:convert';

CartItem cartItemFromJson(String str) => CartItem.fromJson(json.decode(str));

String cartItemToJson(CartItem data) => json.encode(data.toJson());
class CartItem {
  CartData data;

  CartItem({this.data});

  CartItem.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CartData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CartData {
  int id;
  List<CartProducts> products;
  int userId;
  dynamic amount;
  dynamic baseAmount;
  dynamic deliveryCharge;
  dynamic discount;
  String couponCode;
  int couponId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  CartData(
      {this.id,
      this.products,
      this.userId,
      this.amount,
      this.baseAmount,
      this.deliveryCharge,
      this.discount,
      this.couponCode,
      this.couponId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['products'] != null) {
      products = new List<CartProducts>();
      json['products'].forEach((v) {
        products.add(new CartProducts.fromJson(v));
      });
    }
    userId = json['user_id'];
    amount = json['amount'];
    baseAmount = json['base_amount'];
    deliveryCharge = json['delivery_charge'];
    discount = json['discount'];
    couponCode = json['coupon_code'];
    couponId = json['coupon_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['base_amount'] = this.baseAmount;
    data['delivery_charge'] = this.deliveryCharge;
    data['discount'] = this.discount;
    data['coupon_code'] = this.couponCode;
    data['coupon_id'] = this.couponId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class CartProducts {
  int productId;
  int noOfUnits;
  dynamic baseRate;
  dynamic rate;
  String title;
  String imageUrl;

  CartProducts(
      {this.productId,
      this.noOfUnits,
      this.baseRate,
      this.rate,
      this.title,
      this.imageUrl});

  CartProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    noOfUnits = json['no_of_units'];
    baseRate = json['base_rate'];
    rate = json['rate'];
    title = json['title'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['no_of_units'] = this.noOfUnits;
    data['base_rate'] = this.baseRate;
    data['rate'] = this.rate;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    return data;
  }
}



class CartItemCounter {
  ProductData product;
  int counter;

  ProductData get getid => product;
  int get getcounter => counter;
  inccount(int c) {
    this.counter += c;
    return counter;
  }

  CartItemCounter({this.product, this.counter});
}

class ProductModel extends ChangeNotifier {
  List<CartItemCounter> productlist = [];
  int countitem = 0;
  removeItem(int index) {
    productlist.length > 0 ?? productlist.removeAt(index);
    notifyListeners();
  }

  clearList(){
    productlist.clear();
    notifyListeners();
  }

  totalprice() {
    int tprice = 0;
    if (productlist.length == 0) {
      tprice = 0;
    } else {
      for (int i = 0; i < productlist.length; i++) {
        tprice += productlist[i].product.rate[0].baseAmount;
      }
    }

    notifyListeners();
    return tprice;
  }

  addTaskInList(ProductData pro, int counter) {
    CartItemCounter taskModel = CartItemCounter(product: pro, counter: counter);
    print(taskModel.inccount(counter));
    productlist.add(taskModel);
    countitem += 1;

    notifyListeners();
    //code to do
  }
}
