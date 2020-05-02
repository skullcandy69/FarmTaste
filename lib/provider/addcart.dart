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
  var response = await http.post(ADDTOCART, headers: {
    "Authorization": token,
  }, body: {
    "product_id": id.toString(),
    "no_of_units": unit.toString()
  });
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
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
  var response = await http.put(UPDATECARTITEM + id, headers: {
    "Authorization": token,
  }, body: {
    "no_of_units": unit.toString()
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
  var response = await http.delete(
    DELETECARTITEMS + id,
    headers: {
      "Authorization": token,
    },
  );

  if (response.statusCode == 200) {
    print('deleted');
    return true;
  } else {
    print('failed');
    return false;
  }
}

Future<List<dynamic>> myCart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.get(MYCART, headers: {"Authorization": token});
  var r = jsonDecode(response.body);
  print(r['data'][0]['id']);
  CartItem cartItem = CartItem.fromJson(json.decode(response.body));
  double sum = 0;
  for (int i = 0; i < cartItem.data.length; i++) {
    if (cartItem.data[i].noOfUnits > 0) {
      sum += cartItem.data[i].rate * cartItem.data[i].noOfUnits;
    }
  }
  var result = [cartItem.data, sum];

  return result;
}
