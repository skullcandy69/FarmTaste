import 'dart:convert';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/slots.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/OrderComplete.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/paymentbanner.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic cart;
  final dynamic totalamount;
  final dynamic amount;
  final SlotData slot;
  PaymentScreen({this.cart, this.totalamount, this.amount, this.slot});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay _razorpay;
  bool isLoading = true;
  @override
  void initState() {
    print(widget.slot.startTime + '-' + widget.slot.endTime);
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
  }

  void openCheckout(paymethod, method, wallet, res) async {
    // print(widget.amount.toStringAsFixed(1));
    cartid = await createOrder(
        widget.cart.id, method, widget.amount, res.user.address, widget.slot);
    if (useWallet == true) {
      var r = await http.post(Uri.parse(UPDATEWALLET),
          headers: {"Authorization": token},
          body: {"type": "subtract", "amount": walletamount.toString()});
      print("this is wallet" + r.body);
    }
    var options = {
      'key': LIVEKEY,
      'amount': (netamountpay * 100).toInt(),
      'name': 'Expecto',
      'description': 'Order Payment',
      'prefill': {
        "name": res.user.name,
        'contact': res.user.mobileNo,
        'email': res.user.email,
        'method': paymethod
      },
      'external': {
        'wallet': ['paytm']
      },
      "currency": "INR",
      "payment_capture": 1,
      "theme": {"color": "#000000"}
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
    // print(token);
    print(widget.slot.startTime + '-' + widget.slot.endTime);
    await http.put(Uri.parse(UPDATEORDERS + cartid), headers: {
      "Authorization": token
    }, body: {
      "payment_status": "success",
      "transaction_id": response.paymentId,
      "transacted_at": DateTime.now().toString(),
    });
    changeScreenRepacement(
        context,
        OrderSuccess(
          deliveryCharge: widget.cart.deliveryCharge,
          discount: widget.cart.discount,
        ));
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    await http.put(Uri.parse(UPDATEORDERS + cartid),
        headers: {"Authorization": token}, body: {"payment_status": 'failure'});
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static const snackBar = SnackBar(
    content: Text('Payment Failed Please Try again'),
    backgroundColor: red,
  );
  void _handlePaymentWallet(ExternalWalletResponse response) {}

  void _basicContentEasyDialog(BuildContext context) {
    EasyDialog(
        topImage: NetworkImage(
            'https://www.digitalpaymentguru.com/wp-content/uploads/2019/08/Transaction-Failed.png'),
        height: 300,
        closeButton: true,
        contentList: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   // color: pcolor,
          //   height: 50,
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: Text('Retry')),
          // )
        ]).show(context);
  }

  bool useWallet = false;
  Result res;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var response = await http.get(
      Uri.parse(ME),
      headers: {"Authorization": token},
    );
    Result result = Result.fromJson(json.decode(response.body));
    setState(() {
      res = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        await createOrder(widget.cart.id, 'cod', widget.amount,
                            res.user.address, widget.slot);

                        changeScreenRepacement(
                            context,
                            OrderSuccess(
                              deliveryCharge: widget.cart.deliveryCharge,
                              discount: widget.cart.discount,
                            ));
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
                          openCheckout('upi', 'online', useWallet, res),
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
                          openCheckout('netbanking', 'online', useWallet, res),
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
                          openCheckout('debitcard', 'online', useWallet, res),
                    ),
                    ListTile(
                      leading: Text(
                        'External Wallets (FreeCharge,PayZapp)',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          openCheckout('wallets', 'online', useWallet, res),
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
                                  "₹" +
                                      widget.cart.baseAmount.toStringAsFixed(1),
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
                                Text(
                                    "₹" + widget.cart.amount.toStringAsFixed(1))
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
                                          widget.cart.discount
                                              .toStringAsFixed(1))
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
                                Text("₹" + netamountpay.toStringAsFixed(1)),
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
                                  color: pcolor,
                                  controller: _btnController,
                                  child: Text(
                                    'Place Order',
                                    style: TextStyle(color: white),
                                  ),
                                  onPressed: () async {
                                    // authprovider.clearList();
                                    cartid = await createOrder(
                                        widget.cart.id,
                                        'wallet',
                                        widget.amount,
                                        res.user.address,
                                        widget.slot);
                                    await http.put(
                                        Uri.parse(
                                            UPDATEORDERS + cartid.toString()),
                                        headers: {"Authorization": token},
                                        body: {"payment_status": "success"});
                                    await http.post(Uri.parse(UPDATEWALLET),
                                        headers: {
                                          "Authorization": token
                                        },
                                        body: {
                                          "type": "subtract",
                                          "amount": walletamount.toString()
                                        });
                                    // await http.delete(EMPTYCART,
                                    //     headers: {"Authorization": token});
                                    _btnController.success();
                                    changeScreenRepacement(
                                        context,
                                        OrderSuccess(
                                          deliveryCharge:
                                              widget.cart.deliveryCharge,
                                          discount: widget.cart.discount,
                                        ));
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
