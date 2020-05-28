import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/History.dart';
import 'package:grocery/widgets/helpDialog.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ShowOrders extends StatelessWidget {
  final HistoryData order;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  ShowOrders({this.order});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: pcolor,
          title: Text('Order Details'),
        ),
        body: Container(
            child: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              Divider(
                thickness: 7,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Order Id - " + order.orderId.toString(),
                      style: TextStyle(fontSize: 15, color: grey),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Order Status'),
                    Text(order.orderStatus)
                  ],
                ),
              )
            ],
          ),
          ExpansionTile(
            title: Text('View all Products'),
            initiallyExpanded: false,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .70,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: order.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 80,
                                width: 90,
                                child: Image.network(
                                  order.products[index].imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        order.products[index].title
                                            .toString()
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("₹" +
                                          order.products[index].rate.toString())
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${order.products[index].noOfUnits.toString()} Quantity',
                                        style: TextStyle(color: grey),
                                      ),
                                      Text(
                                          '₹ ${(order.products[index].noOfUnits * order.products[index].rate).toString()}')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Divider(),
          InkWell(
            onTap: () {
              basicContentEasyDialog(
                  context, "OrderId: ${order.orderId.toString()}");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Need some help?',
                    style: TextStyle(color: blue),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Shipping Details',
                        style: TextStyle(
                          color: grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        order.user.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    order.deliveryAddress,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Email:'),
                      order.user.email != null
                          ? Text(
                              order.user.email,
                            )
                          : Text(''),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Phone no:'),
                      order.user.mobileNo != null
                          ? Text(
                              "+91 " + order.user.mobileNo,
                            )
                          : Text('')
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Price Details',
                        style: TextStyle(
                          color: grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "List Price",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        order.baseAmount.toString(),
                        style: TextStyle(
                            color: grey,
                            decoration: TextDecoration.lineThrough),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Selling Price',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text((order.amount - order.deliveryCharge).toString())
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total amount'),
                      Text(order.amount.toString()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Payment Mode'),
                      Text(order.paymentMode.toUpperCase()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RoundedLoadingButton(
            width: 150,
            height: 40,
            controller: _btnController,
            onPressed: () {
              Timer(Duration(seconds: 2), () {
                _btnController.success();
              });
            },
            color: red,
            child: Text(
              "Cancle Order",
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
          )
        ])));
  }
}
