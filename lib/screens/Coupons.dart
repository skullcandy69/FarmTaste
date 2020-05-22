import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/couponsModel.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Coupon extends StatefulWidget {
  final dynamic amount;

  const Coupon({Key key, this.amount}) : super(key: key);

  @override
  _CouponState createState() => _CouponState();
}

String token;
Future<List<CouponList>> getCoupons() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  token = pref.getString('token');
  var response = await http.get(COUPON, headers: {"Authorization": token});
  Coupons coupons = Coupons.fromJson(json.decode(response.body));
  return coupons.data;
}

class _CouponState extends State<Coupon> {
  @override
  void initState() {
    super.initState();
    getCoupons();
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Offers'),
        backgroundColor: pcolor,
      ),
      body: FutureBuilder(
        future: getCoupons(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: Loader(),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].code,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: green),
                                  ),
                                  RaisedButton( 
                                      color: green,
                                       onPressed: widget.amount>snapshot.data[index].minimumCartValue?() async {
                                        var res = await http.put(
                                            APPLYCOUPON +
                                                snapshot.data[index].id
                                                    .toString(),
                                            headers: {
                                              "Authorization": token
                                            },
                                        );
                                        print(res.body);
                                        key.currentState.showSnackBar(SnackBar(
                                          content: Text(
                                            "Coupon Applied",
                                            style: TextStyle(color: blue),
                                          ),
                                          backgroundColor: white,
                                        ));
                                        Navigator.pop(context);
                                      }:(){
                                         key.currentState.showSnackBar(SnackBar(
                                          content: Text(
                                            "Min cart value should be ₹" + snapshot.data[index].minimumCartValue.toString(),
                                            style: TextStyle(color: blue),
                                          ),
                                          backgroundColor: white,
                                        ));
                                      },
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(color: white),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Get ${snapshot.data[index].offPercentage}% discount ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Use code ${snapshot.data[index].code} & get ${snapshot.data[index].offPercentage}% discount \n upto Rs.${snapshot.data[index].offAmount} on orders above Rs.${snapshot.data[index].minimumCartValue}',
                                    style: TextStyle(color: grey, fontSize: 15),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
