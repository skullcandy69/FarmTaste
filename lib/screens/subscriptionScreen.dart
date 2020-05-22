import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/Subscription.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  getSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.get(
      GETSUBS,
      headers: {"Authorization": token},
    );
    print(response.body);
    Subscriptions subscriptions =
        Subscriptions.fromJson(json.decode(response.body));
    setState(() {
      list = subscriptions.data;
    });
  }

  List<SubscriptionData> list;
  @override
  void initState() {
    super.initState();
    getSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Subscriptions'),
          backgroundColor: pcolor,
        ),
        body: list == null
            ? Container(
                child: Center(
                  child: Loader(),
                ),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  if (list.length == 0) {
                    return Image.asset('images/emptycart.png');
                  } else {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.grey[350],
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            
                            children: <Widget>[
                              Container(
                                  width: 80,
                                  height: 80,
                                  child: Image.network(
                                      list[index].product.imageUrl)),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        list[index]
                                            .product
                                            .title
                                            .toString()
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Quantity " +
                                            list[index]
                                                .product
                                                .noOfUnits
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "₹" +
                                                  list[index].amount.toString(),
                                              style: TextStyle(
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(alignment: Alignment.topRight,child: FlatButton(child: Text('Edit'),onPressed: (){},))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ));
  }
}
