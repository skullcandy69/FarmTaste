import 'dart:convert';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addToCart(id, unit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(Uri.parse(ADDTOCART), headers: {
    "Authorization": token,
  }, body: {
    "product_id": id.toString(),
    "no_of_units": unit.toString()
  });
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateCart(id, unit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(Uri.parse(ADDTOCART), headers: {
    "Authorization": token,
  }, body: {
    "no_of_units": unit.toString(),
    "product_id": id
  });

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deletCartItem(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.put(Uri.parse(ADDTOCART), headers: {
    "Authorization": token,
  }, body: {
    "no_of_units": "0",
    "product_id": id
  });
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<CartItem> myCart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.get(Uri.parse(MYCART), headers: {"Authorization": token});
  CartItem cartItem = CartItem.fromJson(json.decode(response.body));
  return cartItem;
}

Future<String> createOrder(cartId, mode, amount, address,slot) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  print(amount);
  var response = await http.post(Uri.parse(ORDERS), headers: {
    "Authorization": token
  }, body: {
    "cart_id": cartId.toString(),
    "payment_mode": mode,
    "amount": amount,
    "slot_time":slot.startTime+' - '+slot.endTime
  });
  print(response.body);
  var res = json.decode(response.body);
  print(res);
  return res['data']['id'].toString();
}

// Future<void> updateOrder(status, id) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String token = prefs.getString('token');
//    await http.put(ORDERS + "\id",
//       headers: {"Authorization": token}, body: {"payment_status": status});
// }

Future<String> recurringOrder(String id, nou, sdate, edate, subtype) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.post(Uri.parse(RECURRINGORDER), headers: {
    "Authorization": token
  }, body: {
    "product_id": id,
    "no_of_units": nou,
    "start_date": sdate,
    "end_date": edate,
    "subscription_type": subtype
  });
  if (response.statusCode == 200) {
    return 'Success';
  } else if (json.decode(response.body)['code'] == 107) {
    return "Insufficient Wallet Funds !";
  } else {
    return json.decode(response.body)['message'];
  }
}

String getGstPrice(ProductData product) {
  //  if (product.rate[0].discountedAmount == null ||
  //           product.rate[0].discountedAmount == 0) {
  if (product.isUnderGst == true) {
    dynamic gstrate =
        product.sellingPrice + (product.sellingPrice * product.gstRate) / 100;
        gstrate *=10;
        gstrate = gstrate.ceilToDouble();
        gstrate/=10;
    return gstrate.toString();
  } else {
    
    return product.sellingPrice.toString() ;
  }
  // } else {
  // if (product.isUnderGst == true) {
  //   dynamic gstrate = product.rate[0].discountedAmount +
  //       (product.rate[0].discountedAmount * product.gstRate) / 100;
  //   return gstrate.toString();
  // } else {
  //   return product.rate[0].discountedAmount.toString();
  // }
  // }
}
