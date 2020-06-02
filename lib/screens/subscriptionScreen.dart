import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/Subscription.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
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
          title: Row(
            children: <Widget>[
              Text('Subscriptions'),
              FittedBox(
                  fit: BoxFit.cover,
                  child: Hero(
                    tag: 'plan',
                    child: Container(
                        height: 45,
                        width: 45,
                        child: Image.asset('images/plan.png')),
                  ))
            ],
          ),
          backgroundColor: pcolor,
        ),
        body: list == null
            ? Container(
                child: Center(
                  child: Loader(),
                ),
              )
            : list.length == 0
                ? Container(height: MediaQuery.of(context).size.height ,child: Image.asset('images/emptycart.png',fit: BoxFit.cover,))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderShow(
                        data: list[index],
                      );
                    },
                  ));
  }
}

class OrderShow extends StatefulWidget {
  final SubscriptionData data;

  const OrderShow({Key key, this.data}) : super(key: key);
  @override
  _OrderShowState createState() => _OrderShowState();
}

class _OrderShowState extends State<OrderShow> {
  bool isLoading = false;
  int _itemcounter;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String message = 'Cancel';
  Future<void> updateOrder(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.delete(
      BASE_URL + "/subscription/" + "$id",
      headers: {"Authorization": token},
    );
    print(response.body);
    if (response.statusCode == 200) {
      _btnController.success();
    } else {
      setState(() {
        message = json.decode(response.body)['message'];
      });
      _btnController.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    _itemcounter = widget.data.product.noOfUnits;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Image.network(widget.data.product.imageUrl)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        widget.data.product.title.toString().toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      AutoSizeText(
                        "Quantity " + widget.data.product.noOfUnits.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "₹" + widget.data.amount.toString(),
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
              isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 75,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: blue)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _itemcounter == 0
                                  ? Container()
                                  : InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _itemcounter--;
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: blue,
                                      ),
                                    ),
                              _itemcounter == 0
                                  ? Text(
                                      'ADD',
                                      style: TextStyle(color: blue),
                                    )
                                  : Text(
                                      _itemcounter.toString(),
                                      style: TextStyle(color: blue),
                                    ),
                              InkWell(
                                onTap: () {
                                  print('inc');
                                  setState(() {
                                    _itemcounter++;
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  color: blue,
                                ),
                              ),
                            ],
                          )),
                        ),
                        RoundedLoadingButton(
                          height: 30,
                          width: 60,
                          controller: _btnController,
                          onPressed: () => updateOrder(widget.data.id),
                          child: AutoSizeText(
                            " " + message + " ",
                            style: TextStyle(color: white),
                          ),
                          color: red,
                        )
                      ],
                    )
                  : Container(),
              Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    child: isLoading ? Text("Save") : Text('Edit'),
                    onPressed: () => setState(() {
                      isLoading = !isLoading;
                    }),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
