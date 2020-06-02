import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

CartItem cartItemFromJson(String str) => CartItem.fromJson(json.decode(str));

String cartItemToJson(CartItem data) => json.encode(data.toJson());

class CartItem {
  CartData data;
  List<ProductData> extra;

  CartItem({this.data, this.extra});

  CartItem.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CartData.fromJson(json['data']) : null;
    if (json['extra'] != null) {
      extra = new List<ProductData>();
      json['extra'].forEach((v) {
        extra.add(new ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.extra != null) {
      data['extra'] = this.extra.map((v) => v.toJson()).toList();
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
  dynamic couponId;
  dynamic createdAt;
  String updatedAt;
  dynamic deletedAt;

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

class CartProducts extends Equatable {
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

  @override
  List<Object> get props => [productId];
}

class ProductModel extends ChangeNotifier {
  List<ProductData> productlist = [];

  List<ProductData> getProductList() {
    print(productlist.toSet().toList().length.toString() + "hello");
    return productlist.toSet().toList();
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token!=null){
        var response = await http.get(MYCART, headers: {"Authorization": token});
    CartItem cartItem = CartItem.fromJson(json.decode(response.body));
    productlist.clear();
    for (int i = 0; i < cartItem.extra.length; i++) {
     productlist.add(cartItem.extra[i]);
        notifyListeners();
    }
    }else{
      print('No Token');
    }
  
  }

  removeItem(ProductData product) {
    productlist.remove(product);
    print('removed len' + productlist.length.toString());
    notifyListeners();
  }

  void removeProduct(ProductData product) {
    productlist.removeWhere((p) => p == product);
    notifyListeners();
  }

  int getQuanity(int id) => productlist.where((p) => id == p.id).length;

  clearList() {
    productlist.clear();
    notifyListeners();
  }

  dynamic get tprice => totalprice();
  dynamic totalprice() {
    dynamic tprice = 0;
    if (productlist.length == 0) {
      tprice = 0;
    } else {
      for (int i = 0; i < productlist.length; i++) {
        if (productlist[i].rate[0].discountedAmount == null ||
            productlist[i].rate[0].discountedAmount == 0) {
          if (productlist[i].isUnderGst == true) {
            dynamic gstrate = productlist[i].rate[0].baseAmount +
                (productlist[i].rate[0].baseAmount * productlist[i].gstRate) /
                    100;
            tprice += gstrate;
          } else {
            tprice += productlist[i].rate[0].baseAmount;
          }
        } else {
          if (productlist[i].isUnderGst == true) {
            dynamic gstrate = productlist[i].rate[0].discountedAmount +
                (productlist[i].rate[0].discountedAmount *
                        productlist[i].gstRate) /
                    100;
            tprice += gstrate;
          } else {
            tprice += productlist[i].rate[0].discountedAmount;
          }
        }
      }
    }
    // notifyListeners();
    return tprice;
  }

  addTaskInList(ProductData pro) {
    productlist.add(pro);
    notifyListeners();
  }
}
