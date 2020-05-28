import 'dart:async';
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
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
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
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }

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
                      Text(user.name ?? '',
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
                      InkWell(
                        onTap: () {
                          print('00');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return RequestMoneyDialog(user);
                              });
                        },
                        child: Text(
                          "Add money to wallet",
                          style: TextStyle(color: blue),
                        ),
                      )
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
    switch (transaction.orderStatus) {
      case 'success':
        transactionName = "Completed";
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

class RequestMoneyDialog extends StatefulWidget {
  final dynamic user;

  const RequestMoneyDialog(this.user);
  @override
  _RequestMoneyDialogState createState() => _RequestMoneyDialogState();
}

class _RequestMoneyDialogState extends State<RequestMoneyDialog> {
  bool isRequesting = false;
  Razorpay _razorpay;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController textEditingController =
      TextEditingController(text: '100');
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentWallet);
  }

  String token;
  String message = '';
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print((widget.user.wallet + int.parse(textEditingController.text))
        .toString()
        .runtimeType);
    await http.put(ME, headers: {
      "Authorization": token
    }, body: {
      "wallet": (widget.user.wallet + int.parse(textEditingController.text))
          .toString()
    });
    _btnController.success();
    Timer(Duration(seconds: 2), () => Navigator.pop(context));
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print('fail ' + response.message);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    setState(() {
      if(response.message=="Payment Cancelled")
      message = "Invalid Amount";
    });
    _btnController.reset();
  }

  void _handlePaymentWallet(ExternalWalletResponse response) {
    print('wallet ' + response.walletName);
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_9xPUvXMTVSbgW5',
      'amount': (int.parse(textEditingController.text) * 100).toInt(),
      'name': 'farmtaste',
      'description': 'Order Payment',
      'prefill': {
        "name": widget.user.name,
        'contact': widget.user.mobileNo,
        'email': widget.user.email,
      },
      "image":
          'https://merriam-webster.com/assets/mw/images/article/art-wap-landing-mp-lg/meanwhile-2453-cc63cdb89c527209296a3ec7ffd9ee59@1x.jpg',
      'external': {
        'wallet': ['paytm']
      },
      "currency": "INR",
      "payment_capture": 1,
      "theme": {"color": "#32cd32"}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(child: Text('REQUEST MONEY')),
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: Form(
            key: _formkey,
            child: new TextFormField(
              controller: textEditingController,
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Required';
                } else if (int.parse(value) < 100) {
                  return 'Minimum amount 100';
                }
                return null;
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.monetization_on),
                  labelText: "AMOUNT",
                  hintText: "0",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  )),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(message, style: TextStyle(color: red))],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 100,
            child: RoundedLoadingButton(
              controller: _btnController,
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  openCheckout();
                } else {
                  _btnController.reset();
                }
              },
              child: Text(
                'ADD TO WALLET',
                style: TextStyle(color: white),
              ),
              color: green,
            ),
          ),
        )
      ],
    );
  }
}
