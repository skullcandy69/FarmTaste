import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/models/products.dart';

CartItem cartItemFromJson(String str) => CartItem.fromJson(json.decode(str));

String cartItemToJson(CartItem data) => json.encode(data.toJson());

class CartItem {
    List<CartData> data;

    CartItem({
        this.data,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        data: List<CartData>.from(json["data"].map((x) => CartData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CartData {
    int id;
    int productId;
    int userId;
    double rate;
    int noOfUnits;
    DateTime createdAt;
    DateTime updatedAt;
    CartProduct product;

    CartData({
        this.id,
        this.productId,
        this.userId,
        this.rate,
        this.noOfUnits,
        this.createdAt,
        this.updatedAt,
        this.product,
    });

    factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        rate: json["rate"].toDouble(),
        noOfUnits: json["no_of_units"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: CartProduct.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "rate": rate,
        "no_of_units": noOfUnits,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
    };
}

class CartProduct {
    String type;
    int id;
    String title;
    int subCategoryId;
    String imageUrl;
    bool isUnderGst;
    double gstRate;
    List<Rate> rate;

    CartProduct({
        this.type,
        this.id,
        this.title,
        this.subCategoryId,
        this.imageUrl,
        this.isUnderGst,
        this.gstRate,
        this.rate,
    });

    factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        type: json["__type"],
        id: json["id"],
        title: json["title"],
        subCategoryId: json["sub_category_id"],
        imageUrl: json["image_url"],
        isUnderGst: json["is_under_gst"],
        gstRate: json["gst_rate"] == null ? null : json["gst_rate"].toDouble(),
        rate: List<Rate>.from(json["rate"].map((x) => Rate.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "__type": type,
        "id": id,
        "title": title,
        "sub_category_id": subCategoryId,
        "image_url": imageUrl,
        "is_under_gst": isUnderGst,
        "gst_rate": gstRate == null ? null : gstRate,
        "rate": List<dynamic>.from(rate.map((x) => x.toJson())),
    };
}

class Rate {
    String type;
    int id;
    int baseAmount;
    int discountedAmount;

    Rate({
        this.type,
        this.id,
        this.baseAmount,
        this.discountedAmount,
    });

    factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        type: json["__type"],
        id: json["id"],
        baseAmount: json["base_amount"],
        discountedAmount: json["discounted_amount"] == null ? null : json["discounted_amount"],
    );

    Map<String, dynamic> toJson() => {
        "__type":type,
        "id": id,
        "base_amount": baseAmount,
        "discounted_amount": discountedAmount == null ? null : discountedAmount,
    };
}





class CartItemCounter{
  ProductData product;
  int counter;
  
  ProductData get getid =>product;
  int get getcounter => counter;
  inccount(int c){
    this.counter+=c;
    return counter;
  }
  CartItemCounter({this.product,this.counter});
}

class ProductModel extends ChangeNotifier {
  List<CartItemCounter> productlist = [];
  int countitem=0;
  removeItem(int index) {
    productlist.length > 0 ??productlist.removeAt(index);
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

  addTaskInList(ProductData pro,int counter) {
    CartItemCounter taskModel = CartItemCounter(product: pro,counter: counter);
    print(taskModel.inccount(counter));
    productlist.add(taskModel);
    countitem+=1;
    
    notifyListeners();
    //code to do
  }
}