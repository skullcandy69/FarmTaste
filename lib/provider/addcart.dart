import 'dart:convert';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addToCart(id, unit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(ADDTOCART, headers: {
    "Authorization": token,
  }, body: {
    "product_id": id.toString(),
    "no_of_units": unit.toString()
  });
  print('Response status: ${response.statusCode}');
  if (response.statusCode == 200) {
    return true;
  } else {
    print('failed');
    return false;
  }
}

Future<bool> updateCart(id, unit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(ADDTOCART, headers: {
    "Authorization": token,
  }, body: {
    "no_of_units": unit.toString(),
    "product_id": id
  });

  if (response.statusCode == 200) {
    return true;
  } else {
    print('failed');
    return false;
  }
}

Future<bool> deletCartItem(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(ADDTOCART, headers: {
    "Authorization": token,
  }, body: {
    "no_of_units": "0",
    "product_id": id
  });
  if (response.statusCode == 200) {
    print('deleted');
    return true;
  } else {
    print('failed');
    return false;
  }
}

Future<CartItem> myCart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.get(MYCART, headers: {"Authorization": token});
  // print(response.body);
  CartItem cartItem = CartItem.fromJson(json.decode(response.body));
  // print(cartItem.data.amount);
  return cartItem;
}

Future<String> createOrder(cartId, mode, amount, address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  print(amount);
  var response = await http.post(ORDERS, headers: {
    "Authorization": token
  }, body: {
    "cart_id": cartId.toString(),
    "payment_mode": mode,
    "amount": amount.toStringAsFixed(2),
  });
  var res = json.decode(response.body);
  print(response.body);
  return res['data']['id'].toString();
}

Future<void> updateOrder(status, id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(ORDERS + "\id",
      headers: {"Authorization": token}, body: {"payment_status": status});
  print(response.body);
}

Future<String> recurringOrder(String id, nou, sdate, edate, subtype) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.post(RECURRINGORDER, headers: {
    "Authorization": token
  }, body: {
    "product_id": id,
    "no_of_units": nou,
    "start_date": sdate,
    "end_date": edate,
    "subscription_type": subtype
  });
  print(response.body);
  if (response.statusCode == 200) {
    return 'Success';
  } else if (json.decode(response.body)['code'] == 107) {
    return "Insufficient Wallet Funds !";
  } else {
    return json.decode(response.body)['message'];
  }
}


String getGstPrice(ProductData product){
   if (product.rate[0].discountedAmount == null ||
            product.rate[0].discountedAmount == 0) {
          if (product.isUnderGst == true) {
            dynamic gstrate = product.rate[0].baseAmount +
                (product.rate[0].baseAmount * product.gstRate) /
                    100;
            return  gstrate.toString();
          } else {
            return product.rate[0].baseAmount.toString();
          }
        } else {
          if (product.isUnderGst == true) {
            dynamic gstrate = product.rate[0].discountedAmount +
                (product.rate[0].discountedAmount *
                        product.gstRate) /
                    100;
           return gstrate.toString();
          } else {
           return product.rate[0].discountedAmount.toString();
          }
        }
      }
