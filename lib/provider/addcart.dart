import 'dart:convert';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addToCart(id, unit) async {
  print(id);
  print(unit);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  print(token.runtimeType);
  var response = await http.put(ADDTOCART, headers: {
    "Authorization": token,
  }, body: {
    "product_id": id.toString(),
    "no_of_units": unit.toString()
  });
  // print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
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
  print(token.runtimeType);
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
  print(response.body);
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
  print(response.body);
  CartItem cartItem = CartItem.fromJson(json.decode(response.body));
  print(cartItem.data.amount);
  return cartItem;
}

Future<String> createOrder(cartId, mode, amount, address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  print(address);
  var response = await http.post(ORDERS, headers: {
    "Authorization": token
  }, body: {
    "cart_id": cartId.toString(),
    "payment_mode": mode,
    "amount": amount.toString(),
  });
  var res = json.decode(response.body);
  print(response.body);
  return res['data']['id'].toString();
}

dynamic useWallet(tamount, walletamount) {
  dynamic amount;
  if (walletamount >= tamount) {
    amount = walletamount - tamount;
  } else {
    
  }
  return null;
}

Future<void> updateOrder(status, id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(ORDERS + "\id",
      headers: {"Authorization": token}, body: {"payment_status": status});
  print(response.body);
}
