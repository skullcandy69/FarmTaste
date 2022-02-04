import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/screens/showOrders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/History.dart';
import 'package:intl/intl.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewBill extends StatefulWidget {
  @override
  _ViewBillState createState() => _ViewBillState();
}

class TransactionWidget extends StatelessWidget {
  final HistoryData transaction;
  final VoidCallback fun;
  TransactionWidget({this.transaction, this.fun});

  @override
  Widget build(BuildContext context) {
    String transactionName;
    IconData transactionIconData;
    Color color;
    switch (transaction.orderStatus) {
      case 'delivered':
        transactionName = "delivered";
        transactionIconData = Icons.check_circle_outline;
        color = green;
        break;
      case 'cancelled':
        transactionName = "Cancelled";
        transactionIconData = Icons.cancel;
        color = Colors.red;
        break;
      case 'rejected':
        transactionName = "Rejected";
        transactionIconData = Icons.cancel;
        color = Colors.red;
        break;
      case "pending":
        transactionName = "Pending";
        transactionIconData = Icons.blur_circular;
        color = Colors.orange;
        break;
      case "on the way":
        transactionName = "on the way";
        transactionIconData = Icons.update;
        color = Colors.indigoAccent;
        break;
    }
    return GestureDetector(
      onTap: () {
        changeScreen(
            context,
            ShowOrders(
              order: transaction,
              fun: fun,
            ));
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
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
            Flexible(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      "images/order.png",
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 15.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Icon(
                          transactionIconData,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 5.0),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          AutoSizeText(
                            transaction.orderId.toString(),
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      AutoSizeText(
                        " ₹${transaction.amount - transaction.discount}",
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AutoSizeText(
                          "${DateFormat.E().format(DateTime.parse(transaction.updatedAt).toLocal())}, ${DateFormat.jm().format(DateTime.parse(transaction.updatedAt).toLocal())}",
                          style: TextStyle(color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis),
                      AutoSizeText(
                        "$transactionName",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AutoSizeText(
                        "${DateFormat.yMMMMd().format(DateTime.parse(transaction.updatedAt).toLocal())}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ['Pending','on the way'].contains(transactionName) ?  AutoSizeText("Code:${transaction.deliveryCode}",
                          style: TextStyle(color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis):Text(''),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<HistoryData>> getTransaction() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.get(Uri.parse(HISTORY), headers: {"Authorization": token});
  History trans = History.fromJson(json.decode(response.body));
  return trans.data.reversed.toList();
}

Future<List<HistoryData>> getOrders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response;
  response = await http.get(Uri.parse(ORDERS), headers: {"Authorization": token});
  History trans = History.fromJson(json.decode(response.body));
  return trans.data.reversed.toList();
}

class _ViewBillState extends State<ViewBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: pcolor,
          title: Row(
            children: <Widget>[
              Text('Orders'),
              FittedBox(
                  fit: BoxFit.fill,
                  child: Hero(
                    tag: 'bill',
                    child: Container(
                        height: 25,
                        width: 25,
                        child: Image.asset('images/orderhistory.png')),
                  )),
            ],
          ),
        ),
        body: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TabBar(tabs: [
                  Tab(
                    text: 'UPCOMING ORDERS',
                  ),
                  Tab(text: 'HISTORY')
                ], labelColor: pcolor),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TabBarView(children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder(
                          future: getOrders(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                child: Center(child: Loader()),
                              );
                            } else if (snapshot.data == null) {
                              return Container(
                                child: Center(child: Text('No Orders')),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TransactionWidget(
                                      transaction: snapshot.data[index],
                                      fun: () {
                                        setState(() {});
                                      });
                                },
                              );
                            }
                          }),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder(
                          future: getTransaction(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                child: Center(child: Loader()),
                              );
                            } else if (snapshot.data == null) {
                              return Container(
                                child: Center(child: Text('No Orders')),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TransactionWidget(
                                      transaction: snapshot.data[index]);
                                },
                              );
                            }
                          }),
                    ),
                  ]),
                )
              ],
            )));
  }
}
