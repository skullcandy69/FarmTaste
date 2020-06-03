import 'dart:convert';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/shoppingCart.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/paymentbanner.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic cart;
  final dynamic totalamount;
  final dynamic amount;
  PaymentScreen({this.cart, this.totalamount, this.amount});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay _razorpay;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getUser();
    netamountpay = widget.totalamount;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String cartid;
  dynamic walletamount;
  dynamic netamountpay;
  uwallet(Result res, bool val) {
    if (val) {
      if (res.user.wallet >= widget.totalamount) {
        setState(() {
          walletamount = res.user.wallet - widget.totalamount;
          netamountpay = 0;
        });
      } else if (res.user.wallet < widget.totalamount) {
        setState(() {
          walletamount = 0;
          netamountpay = widget.totalamount - res.user.wallet;
        });
      }
    } else {
      setState(() {
        walletamount = res.user.wallet;
        netamountpay = widget.totalamount;
      });
    }
    print(netamountpay);
    print(walletamount);
  }

  void openCheckout(paymethod, method, wallet, res) async {
    print(widget.amount);
    cartid = await createOrder(
        widget.cart.id, method, widget.amount, res.user.address);
    var options = {
      'key': 'rzp_test_M67sVToP9WnsZP',
      'amount': (netamountpay * 100).toInt(),
      'name': 'farmtaste',
      'description': 'Order Payment',
      'prefill': {
        "name": res.user.name,
        'contact': res.user.mobileNo,
        'email': res.user.email,
        'method': paymethod
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

  String token;
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(response.paymentId);

    var r = await http.put(UPDATEORDERS + cartid, headers: {
      "Authorization": token
    }, body: {
      "payment_status": "success",
      "transaction_id": response.paymentId,
      "transacted_at": DateTime.now().toString()
    });
    print(r.body);
    Provider.of<ProductModel>(context, listen: false).clearList();
    EasyDialog(
        topImage: NetworkImage(
            'https://i2.wp.com/codemyui.com/wp-content/uploads/2015/10/progress-and-tick-icon-animation.gif?fit=880%2C440&ssl=1'),
        height: 320,
        closeButton: false,
        title: Text('Order Successful', style: TextStyle(fontSize: 25)),
        description: Text(
            'We have recieved your order please \n  check order history in your wallet\n'),
        contentList: [  
          Container(
            width: MediaQuery.of(context).size.width,
            color: green,
            height: 50,
            child: FlatButton(
                onPressed: () async {
                  useWallet
                      ? await http.put(ME,
                          headers: {"Authorization": token},
                          body: {"wallet": walletamount.toString()})
                      : print('wallet no use');
                  await http
                      .delete(EMPTYCART, headers: {"Authorization": token});
                  changeScreenRepacement(context, ShoppingCart());
                },
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                )),
          )
        ]).show(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print('fail ' + response.message);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var res = await http.put(UPDATEORDERS + cartid,
        headers: {"Authorization": token}, body: {"payment_status": 'failure'});
    print(res.body);
    _basicContentEasyDialog(context);
  }

  void _handlePaymentWallet(ExternalWalletResponse response) {
    print('wallet ' + response.walletName);
  }

  void _basicContentEasyDialog(BuildContext context) {
    EasyDialog(
        topImage: NetworkImage(
            'https://mk0travelvisaboo9h0g.kinstacdn.com/wp-content/uploads/2017/09/payment_failed.jpg'),
        height: 210,
        closeButton: true,
        contentList: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: green,
            height: 50,
            child: FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('Retry')),
          )
        ]).show(context);
  }

  bool useWallet = false;
  Result res;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var response = await http.get(
      ME,
      headers: {"Authorization": token},
    );
    Result result = Result.fromJson(json.decode(response.body));
    print('new user' + result.user.address);
    setState(() {
      res = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<ProductModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Payments'),
          backgroundColor: pcolor,
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
                    Bannerpayment(
                      status: true,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: useWallet,
                            onChanged: (val) {
                              uwallet(res, val);
                              setState(() {
                                useWallet = val;
                              });
                            }),
                        Text('Use Wallet amount (₹ ${res.user.wallet} )')
                      ],
                    ),
                    ListTile(
                      leading: Text(
                        'Cash on delivery(COD)',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        authprovider.clearList();
                        EasyDialog(
                            topImage: NetworkImage(
                              'https://i2.wp.com/codemyui.com/wp-content/uploads/2015/10/progress-and-tick-icon-animation.gif?fit=880%2C440&ssl=1',
                            ),
                            height: 320,
                            closeButton: false,
                            title: Text('Order Successful',
                                style: TextStyle(fontSize: 25)),
                            description: Text(
                                'We have recieved your order please \n  check order history in your wallet\n'),
                            contentList: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: green,
                                height: 50,
                                child: FlatButton(
                                    onPressed: () async {
                                      await createOrder(widget.cart.id, 'cod',
                                          widget.amount, res.user.address);

                                      await http.delete(EMPTYCART,
                                          headers: {"Authorization": token});
                                      changeScreenRepacement(
                                          context, ShoppingCart());
                                    },
                                    child: Text(
                                      'Continue Shopping',
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )
                            ]).show(context);
                      },
                    ),
                    ListTile(
                      leading: Text(
                        'Pay with UPI',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          openCheckout('upi', 'razor_pay', useWallet, res),
                    ),
                    ListTile(
                      leading: Text(
                        'NetBanking',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => openCheckout(
                          'netbanking', 'razor_pay', useWallet, res),
                    ),
                    ListTile(
                      leading: Text(
                        'Debit Card',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => openCheckout(
                          'debitcard', 'razor_pay', useWallet, res),
                    ),
                    ListTile(
                      leading: Text(
                        'Wallets',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          openCheckout('wallets', 'razor_pay', useWallet, res),
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
                                  "₹" + widget.cart.baseAmount.toString(),
                                  style: TextStyle(
                                      color: grey,
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Selling Price',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text("₹" + widget.cart.amount.toString())
                              ],
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Delivery Charge',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text("+ ₹" +
                                    widget.cart.deliveryCharge.toString())
                              ],
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            widget.cart.couponCode == null
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Coupon Discount',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text("- ₹" +
                                          widget.cart.discount.toString())
                                    ],
                                  ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Payable amount'),
                                Text("₹" + netamountpay.toStringAsFixed(2)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    netamountpay == 0
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RoundedLoadingButton(
                                  color: green,
                                  controller: _btnController,
                                  child: Text(
                                    'Place Order',
                                    style: TextStyle(color: white),
                                  ),
                                  onPressed: () async {
                                    authprovider.clearList();
                                    cartid = await createOrder(widget.cart.id,
                                        'cod', widget.amount, res.user.address);
                                    await http.put(
                                        UPDATEORDERS + cartid.toString(),
                                        headers: {"Authorization": token},
                                        body: {"payment_status": "success"});
                                    _btnController.success();
                                    EasyDialog(
                                        topImage: NetworkImage(
                                          'https://i2.wp.com/codemyui.com/wp-content/uploads/2015/10/progress-and-tick-icon-animation.gif?fit=880%2C440&ssl=1',
                                        ),
                                        height: 320,
                                        closeButton: false,
                                        title: Text('Order Successful',
                                            style: TextStyle(fontSize: 25)),
                                        description: Text(
                                            'We have recieved your order please \n  check order history in your wallet\n'),
                                        contentList: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: green,
                                            height: 50,
                                            child: FlatButton(
                                                onPressed: () async {
                                                  print(walletamount);
                                                  await http.put(UPDATEWALLET,
                                                      headers: {
                                                        "Authorization": token
                                                      },
                                                      body: {
                                                        "amount": walletamount
                                                            .toString()
                                                      });
                                                  await http.delete(EMPTYCART,
                                                      headers: {
                                                        "Authorization": token
                                                      });
                                                  changeScreenRepacement(
                                                      context, ShoppingCart());
                                                },
                                                child: Text(
                                                  'Continue Shopping',
                                                  style: TextStyle(
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          )
                                        ]).show(context);
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ));
  }
}
