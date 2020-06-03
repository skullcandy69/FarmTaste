import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/History.dart';
import 'package:grocery/screens/wallet.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewBill extends StatefulWidget {
  @override
  _ViewBillState createState() => _ViewBillState();
}

Future<List<HistoryData>> getTransaction() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.get(HISTORY, headers: {"Authorization": token});
  print(response.body);
  History trans = History.fromJson(json.decode(response.body));
  return trans.data.reversed.toList();
}

Future<List<HistoryData>> getOrders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.get(ORDERS, headers: {"Authorization": token});
  print(response.body);
  History trans = History.fromJson(json.decode(response.body));
  print(trans.data[0].deliveryAddress);
  return trans.data.reversed.toList();
}

class _ViewBillState extends State<ViewBill> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: pcolor,
          title: Row(
            children: <Widget>[
              Text('Orders'),FittedBox(
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
                    text: 'ALL TRANSACTIONS',
                  ),
                  Tab(text: 'FAILED TRANSACTIONS')
                ], labelColor: green),
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
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder(
                          future: getTransaction(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
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
            )));
  }
}
