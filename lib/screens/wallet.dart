import 'dart:convert';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/screens/showOrders.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/History.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Wallet'),
            backgroundColor: pcolor,
          ),
          body: FutureBuilder(
              future: authprovider.getUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(child: Loader()),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          walletDetails(snapshot.data.user),
                          SizedBox(
                            height: 10,
                          ),
                          transactionList(),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // bottomCarouselBar(),
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }

  // bool shouldRefresh(ScrollNotification notification) {
  //   return !widget.isRefreshing;
  // }

  // Future<Null> _handleRefresh() async {
  //   if (widget.isRefreshing) {
  //     await new Future.delayed(new Duration(seconds: 3));
  //     return null;
  //   } else {
  //     widget.onRefresh();
  //   }
  //   await new Future.delayed(new Duration(seconds: 3));

  //   return null;
  // }

  Widget walletDetails(user) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.account_balance, size: 24, color: Colors.green[300]),
              SizedBox(
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user.name,
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      Text(
                        "Available Balance",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "₹ ${user.wallet}",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        user.mobileNo,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      ordersdata = getOrders();
      historydata = getTransaction();
    });
  }

  Future<List<HistoryData>> ordersdata;
  Future<List<HistoryData>> historydata;

  Future<List<HistoryData>> getTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(HISTORY, headers: {"Authorization": token});
    History trans = History.fromJson(json.decode(response.body));
    // print(trans.data.length);

    return trans.data;
  }

  Future<List<HistoryData>> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(ORDERS, headers: {"Authorization": token});
    print(response.body);
    History trans = History.fromJson(json.decode(response.body));
    // print(trans.data[0].cart.products[0].title);
    return trans.data;
  }

  Widget transactionList() {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TabBar(tabs: [
              Tab(
                text: 'ALL TRANSACTIONS',
              ),
              Tab(text: 'FAILED TRANSACTIONS')
            ], labelColor: green),
            Container(
              height: MediaQuery.of(context).size.height * 0.56,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TabBarView(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: FutureBuilder(
                      future: ordersdata,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(child: Loader()),
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: FutureBuilder(
                      future: historydata,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(child: Loader()),
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
        ));
  }
}

// enum TransactionStatus {success,failure,pending}

class TransactionWidget extends StatelessWidget {
  final HistoryData transaction;
  TransactionWidget({this.transaction});

  @override
  Widget build(BuildContext context) {
    String transactionName;
    IconData transactionIconData;
    Color color;
    switch (transaction.paymentStatus) {
      case 'success':
        transactionName = "Paid";
        transactionIconData = Icons.check_circle_outline;
        color = green;
        break;
      case 'failure':
        transactionName = "Failed";
        transactionIconData = Icons.cancel;
        color = Colors.red;
        break;
      case "pending":
        transactionName = "Pending";
        transactionIconData = Icons.blur_circular;
        color = Colors.orange;
        break;
    }
    return GestureDetector(
      onTap: () {
        // print(transaction.products.length);
        changeScreen(
            context,
            ShowOrders(
              order: transaction,
            ));
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
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
                          Text(
                            transaction.orderId.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        " ₹${transaction.amount}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${DateFormat.EEEE().format(DateTime.parse(transaction.updatedAt))}, ${DateFormat.jm().format(DateTime.parse(transaction.updatedAt))}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        "$transactionName",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${DateFormat.yMMMMd().format(DateTime.parse(transaction.updatedAt))}",
                    style: TextStyle(color: Colors.grey[700]),
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
