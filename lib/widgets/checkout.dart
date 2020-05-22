import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/areaModel.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/payments/paymentScreen.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/paymentbanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  final dynamic cart;
  final dynamic totalamount;
  final dynamic amount;

  Checkout({Key key, this.cart, this.totalamount, this.amount});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String token;

  Future<Result> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var response = await http.get(
      ME,
      headers: {"Authorization": token},
    );
    Result res = Result.fromJson(json.decode(response.body));
    var arearesponse = await http.get(
      ALLAREA + res.user.locationId.toString(),
      headers: {"Authorization": token},
    );
    AreaModel area = AreaModel.fromJson(json.decode(arearesponse.body));
    for (var i in area.data) {
      if (i.id == res.user.areaId) {
        selectedValue = i;
      }
    }
    setState(() {
      areaList = area.data;
      name = res.user.name;
      address = res.user.address;
      email = res.user.email;
      mobno = res.user.mobileNo;
      pincode = res.user.pincode;
      landmark = res.user.landmark;
      areaid = res.user.areaId.toString();
      isLoading = false;
    });
    return res;
  }

  List<AreaData> areaList;
  Future<Result> user;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      user = getUser();
    });
  }

  String name = '';
  String address = '';
  String email = '';
  String mobno = '';
  String pincode = '';
  String landmark = '';
  String areaid = '';

  final _formKey = GlobalKey<FormState>();
  AreaData selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Details'),
        backgroundColor: pcolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Loader(),
                    ))
                : Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Bannerpayment(
                          status: false,
                        ),
                        TextFormField(
                          initialValue: name,
                          decoration: InputDecoration(
                            icon: Icon(Icons.account_box),
                            labelText: 'Name*',
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Email*',
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: mobno.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: 'Mobile Number*',
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(() {
                              mobno = val;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            } else if (value.length != 10) {
                              return 'Please enter a 10 digit number';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: address,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          decoration: InputDecoration(
                            icon: Icon(Icons.home),
                            labelText: 'Address*',
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(() {
                              address = val;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: pincode.toString(),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.dialpad),
                                  labelText: 'Pin code*',
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    pincode = val;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Cannot be empty';
                                  } else if (value.length != 6) {
                                    return 'Please enter a 6 digit number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: landmark,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.not_listed_location),
                                  labelText: 'LandMark',
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    landmark = val;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'please select a location';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text('Area*'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10,
                          ),
                          child: DropdownButtonFormField(
                            autovalidate: true,
                            items: areaList.map((AreaData area) {
                              return DropdownMenuItem<AreaData>(
                                  value: area,
                                  child: Text(area.title.toUpperCase(),
                                      style: TextStyle(fontSize: 15)));
                            }).toList(),
                            value: selectedValue,
                            
                            // hint: "Select Area",
                            // label: Text(
                            //   'Area*',
                            //   style: TextStyle(color: grey),
                            // ),
                            // searchHint: "Select Area",
                            // displayClearIcon: false,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                                print('changed' + selectedValue.title);
                                areaid = selectedValue.id.toString();
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'please select a location';
                              }
                              return null;
                            },

                            isExpanded: true,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          child: FlatButton(
                            color: green,
                            onPressed: () async {
                              print(areaid);
                              if (_formKey.currentState.validate()) {
                                print('hell');
                                var response = await http.put(ME, headers: {
                                  "Authorization": token
                                }, body: {
                                  "name": name,
                                  "email": email,
                                  "address": address,
                                  "alternate_no": mobno,
                                  "pincode": pincode,
                                  "landmark": landmark,
                                  "area_id": areaid
                                });
                                if (response.statusCode == 200) {
                                  changeScreenRepacement(
                                      context,
                                      PaymentScreen(
                                          cart: widget.cart,
                                          totalamount: widget.totalamount,
                                          amount: widget.amount));
                                }
                              }
                            },
                            child: Text('Proceed'),
                            textColor: white,
                            splashColor: Colors.green[100],
                          ),
                        ),
                      ],
                    ))),
      ),
    );
  }
}
