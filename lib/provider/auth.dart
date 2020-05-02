import 'dart:async';
import 'dart:convert';
import 'package:grocery/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:grocery/helpers/commons.dart';
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
    Result re = Result.fromJson(json.decode(prefs.getString('response')));
    String token = re.token.toString();
    var response = await http.get(
      ME,
      headers: {"Authorization": token},
    );
    res = Result.fromJson(json.decode(response.body));
   
    print('cleared');
    notifyListeners();
    print('new user' + res.user.id.toString());
    return res;
  }

  Future<bool> updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String token = prefs.getString('token');
  
    var response = await http.put(ME, headers: {
      "Authorization": token
    }, body: {
      "address": adddress.text,
      
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
     
      return true;
    } else {
      print('failed');
      print(res.user.pincode);
      print(res.user.email.runtimeType);

      return false;
    }
  }

  Future<bool> genOtplogin() async {
    _status = status.Authenticating;
    notifyListeners();
    var response = await http.post(OTP, body: {"mobile_no": mobno.text.trim()});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 &&
        json.decode(response.body) == "OTP Generated, Kindly Login") {
      _status = status.Authenticating;
      notifyListeners();

      return true;
    } else {
      print('failed');
      return false;
    }
  }

  Future<bool> genOtpSignup() async {
    _status = status.Authenticating;
    notifyListeners();
    var response = await http.post(OTP, body: {"mobile_no": mobno.text.trim()});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 &&
        json.decode(response.body) == "OTP Generated, Kindly Register") {
      _status = status.Authenticating;
      notifyListeners();
      return true;
    } else {
      print('failed');
      return false;
    }
  }

  Future<bool> inputotp() async {
    var response = await http.post(LOGIN,
        body: {"mobile_no": mobno.text.trim(), "otp": otp.text.trim()});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      _status = status.Authenticated;
      notifyListeners();
      res = Result.fromJson(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('response', json.encode(res));
      prefs.setString('token', res.token);
      print(res.user.id);
      print('success');
      return true;
    } else {
      print('failed');
      _status = status.Authenticating;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(cityId, locationId) async {
    var response = await http.post(SIGNUP, body: {
      "city_id": cityId,
      "location_id": locationId,
      "mobile_no": mobno.text.trim(),
      "otp": otp.text.trim()
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      _status = status.Authenticated;
      notifyListeners();
      res = Result.fromJson(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('response', json.encode(res));
      prefs.setString('token', res.token);

      print(res.user.id);
      print('success');
      return true;
    } else {
      print('failed');
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
    // print(res.token);
      String token =prefs.getString('token');
    if (token == null) {
      _status = status.Unauthenticated;
    } else {
      _status = status.Authenticated;
      // _userModel = await _userServicse.getUserById(user.uid);
      // return _userModel;
    }
    notifyListeners();
  }
}
