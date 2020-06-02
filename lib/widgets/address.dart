import 'dart:async';
import 'dart:convert';
import 'package:grocery/widgets/Loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/user_model.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Result res;
  bool isLoading = true;
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(
      ME,
      headers: {"Authorization": token},
    );
    setState(() {
      res = Result.fromJson(json.decode(response.body));
      address = res.user.address;
      pincode = res.user.pincode;
      isLoading = false;
    });
  }

  @override
  initState() {
    super.initState();
    getUser();
  }

  bool editaddress = false;
  bool nameedit = false;
  String address;
  dynamic pincode;
  final _formkey = GlobalKey<FormState>();
  FocusNode focusaddress = FocusNode();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pcolor,
        title: Row(
          children: <Widget>[
            Text('Deliver Address'),
            FittedBox(
                fit: BoxFit.fill,
                child: Hero(
                  tag: 'address',
                  child: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('images/address.png')),
                ))
          ],
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: Loader(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        height: 250,
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Text(
                                  'Current Address',
                                  style: TextStyle(
                                    color: grey,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      editaddress = true;
                                    });
                                    focusaddress.requestFocus();
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  enabled: editaddress,
                                  focusNode: focusaddress,
                                  maxLines: 3,
                                  initialValue: res.user.address,
                                  decoration: InputDecoration(
                                      labelText: 'Address',
                                      hintText: 'Enter your Address',
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'cannot be empty';
                                    } else if (value.length < 5) {
                                      return 'Enter min 5 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      address = val;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  enabled: editaddress,
                                  initialValue: res.user.pincode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'cannot be empty';
                                    } else if (value.length != 6) {
                                      return ' Invalid pincode';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      pincode = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Pin Code',
                                      hintText: 'Enter Pin Code',
                                      border: InputBorder.none),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  editaddress
                      ? RoundedLoadingButton(
                          child: Text(
                            'Update',
                            style: TextStyle(color: white),
                          ),
                          controller: _btnController,
                          color: green,
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              _formkey.currentState.save();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String token = prefs.getString('token');
                              var response = await http.put(ME, headers: {
                                "Authorization": token
                              }, body: {
                                "address": address,
                                'pincode': pincode
                              });
                              if (response.statusCode == 200) {
                                _btnController.success();
                                Timer(Duration(seconds: 2), () {
                                  _btnController.reset();
                                  setState(() {
                                    editaddress = false;
                                  });
                                });
                              } else {
                                _btnController.stop();
                              }
                            } else {
                              _btnController.reset();
                            }
                          },
                        )
                      : Container()
                ],
              ),
            ),
    );
  }
}
