import 'dart:async';
import 'dart:convert';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum status { Uninitialized, Unauthenticated, Authenticating, Authenticated }

class AuthProvider with ChangeNotifier {
  status _status = status.Unauthenticated;
  final formkey = GlobalKey<FormState>();
  Result res;
  status get Status => _status;
  TextEditingController mobno = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController adddress = TextEditingController();
  TextEditingController pincode = TextEditingController();

  TextEditingController otp = TextEditingController();
  //TextEditingController name = TextEditingController();
  AuthProvider.initialize() {
    _onStateChanged(res);
  }
  Future<Result> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =prefs.getString('token');
    var response = await http.get(
      Uri.parse(ME),
      headers: {"Authorization": token},
    );
    res = Result.fromJson(json.decode(response.body));
    
    notifyListeners();
    return res;
  }

  Future<bool> updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.put(Uri.parse(ME), headers: {
      "Authorization": token
    }, body: {
      "address": adddress.text,
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> genOtplogin() async {
    _status = status.Authenticating;
    notifyListeners();
    var response = await http.post(Uri.parse(OTP), body: {"mobile_no": mobno.text.trim(),"type":"login"});
    
    if (response.statusCode == 200 &&
        json.decode(response.body)['data'] == "OTP Generated, Kindly Login") {
      return json.decode(response.body)['otp'];
    } else {
      return 'Kindly Register First';
    }
  }

  Future<String> genOtpSignup() async {
    _status = status.Authenticating;
    notifyListeners();
    var response = await http.post(Uri.parse(OTP), body: {"mobile_no": mobno.text.trim(),"type":"signup"});
   
    if (response.statusCode == 200 &&
        json.decode(response.body)['data'] ==
            "OTP Generated, Kindly Register") {
      return json.decode(response.body)['otp'];
    } else {
      return 'Already Registered, Please Login';
    }
  }

  Future<bool> inputotp(BuildContext context) async {
    var response = await http.post(Uri.parse(LOGIN),
        body: {"mobile_no": mobno.text.trim(), "otp": otp.text.trim()});
   
    if (response.statusCode == 200) {
      _status = status.Authenticated;
      notifyListeners();
      res = Result.fromJson(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('response', json.encode(res));
      prefs.setString('token', res.token);
      
      Provider.of<ProductModel>(context, listen: false).fetchProducts();

      return true;
    } else {
      _status = status.Authenticating;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(cityId, locationId, code) async {
    var response = code == null
        ? await http.post(Uri.parse(SIGNUP), body: {
            "city_id": cityId,
            "location_id": locationId,
            "mobile_no": mobno.text.trim(),
            "otp": otp.text.trim(),
          })
        : await http.post(Uri.parse(SIGNUP), body: {
            "city_id": cityId,
            "location_id": locationId,
            "mobile_no": mobno.text.trim(),
            "otp": otp.text.trim(),
            "referral_code": code
          });
   
    if (response.statusCode == 200) {
      _status = status.Authenticated;
      notifyListeners();
      res = Result.fromJson(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('response', json.encode(res));
      prefs.setString('token', res.token);

      
      return true;
    } else {
      _status = status.Authenticating;
      notifyListeners();
      return false;
    }
  }

  void clearController() {
    mobno.text = "";
    otp.text = "";
    //email.text = "";
  }

  Future<void> _onStateChanged(Result user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Result res = Result.fromJson(json.decode(prefs.getString('response')));
    String token = prefs.getString('token');
    if (token == null) {
      _status = status.Unauthenticated;
    } else {
      _status = status.Authenticated;
      // _userModel = await _userServicse.getUserById(user.uid);
    }
    notifyListeners();
  }
}
