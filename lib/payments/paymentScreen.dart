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
  @override
  void initState() {
    super.initState();

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

  String cartid;
  dynamic amount;
  void openCheckout(method, wallet, res) async {
    // amount = useWallet(widget.totalamount,res.user.wallet);
    // wallet ? (widget.totalamount - res.user.wallet) : widget.totalamount;
    cartid = await createOrder(
        widget.cart.id, method, widget.amount, res.user.address);
    var options = {
      'key': 'rzp_test_9xPUvXMTVSbgW5',
      'amount': widget.totalamount * 100,
      'name': 'farmtaste',
      'description': 'Order Payment',
      'prefill': {
        "name": res.user.name,
        'contact': res.user.mobileNo,
        'email': res.user.email,
        'method': method
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
    print(cartid);
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
                onPressed: () =>
                    changeScreenRepacement(context, ShoppingCart()),
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                )),
          )
        ]).show(context);
    await http.put(UPDATEORDERS + cartid,
        headers: {"Authorization": token}, body: {"payment_status": "success"});
    // await http.put(ME, headers: {"Authorization": token}, body: {"wallet": ""});
    await http.delete(EMPTYCART, headers: {"Authorization": token});
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
  Future<Result> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var response = await http.get(
      ME,
      headers: {"Authorization": token},
    );
    Result res = Result.fromJson(json.decode(response.body));
    print('new user' + res.user.address);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<ProductModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Payments'),
          backgroundColor: pcolor,
        ),
        body: FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Loader(),
                  ),
                );
              } else {
                return Column(
                  children: <Widget>[
                    Bannerpayment(
                      status: true,
                    ),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(top: 8.0, left: 15, right: 8),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Text(
                    //         snapshot.data.user.name ?? 'Null',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 20),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // ListTile(
                    //     leading: Text(
                    //       "+91 " + snapshot.data.user.mobileNo ?? 'Null',
                    //       overflow: TextOverflow.ellipsis,
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.w300, fontSize: 15),
                    //     ),
                    //     trailing: Text(
                    //       snapshot.data.user.email ?? 'Null',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.w300, fontSize: 15),
                    //     )),
                    // Divider(
                    //   thickness: 5,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15, right: 8),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Text(
                    //         'Saved Address',
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 100,
                    //     decoration: BoxDecoration(
                    //         border: Border.all(),
                    //         borderRadius: BorderRadius.circular(20)),
                    //     child: Column(
                    //       children: <Widget>[
                    //         ListTile(
                    //           leading: Icon(
                    //             Icons.radio_button_checked,
                    //             color: green,
                    //           ),
                    //           title: Text('Home'),
                    //           subtitle: Text(
                    //             snapshot.data.user.address ?? 'Null',
                    //           ),
                    //           trailing: Icon(
                    //             Icons.edit,
                    //           ),
                    //           isThreeLine: true,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: useWallet,
                            onChanged: (val) {
                              setState(() {
                                useWallet = val;
                              });
                            }),
                        Text(
                            'Use Wallet amount (₹ ${snapshot.data.user.wallet} )')
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
                                      await createOrder(
                                          widget.cart.id,
                                          'cod',
                                          widget.amount,
                                          snapshot.data.user.address);

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
                          openCheckout('razor_pay', useWallet, snapshot.data),
                    ),
                    ListTile(
                      leading: Text(
                        'NetBanking',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          openCheckout('razor_pay', useWallet, snapshot.data),
                    ),
                    ListTile(
                      leading: Text(
                        'Debit Card',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          openCheckout('razor_pay', useWallet, snapshot.data),
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
                          openCheckout('razor_pay', useWallet, snapshot.data),
                    ),
                  ],
                );
              }
            }));
  }
}
