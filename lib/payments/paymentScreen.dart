import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/screens/shoppingCart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final Result res;
  final List<CartData> cart;
  final double totalamount;
  PaymentScreen({this.res, this.cart, this.totalamount});
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

  void openCheckout(method) async {
    var options = {
      'key': 'rzp_test_9xPUvXMTVSbgW5',
      'amount': widget.totalamount.toInt() * 100,
      'name': 'farmtaste',
      'description': 'Order Payment',
      'prefill': {
        "name": widget.res.user.name,
        'contact': widget.res.user.mobileNo,
        'email': widget.res.user.email,
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

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Future.delayed(Duration(seconds: 5));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.delete(EMPTYCART, headers: {"Authorization": token});
    changeScreenRepacement(context, ShoppingCart());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('fail ' + response.code.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Details'),
        backgroundColor: pcolor,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15, right: 8),
            child: Row(
              children: <Widget>[
                Text(
                  widget.res.user.name ?? 'Null',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
          ),
          ListTile(
              leading: Text(
                "+91 " + widget.res.user.mobileNo ?? 'Null',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
              ),
              trailing: Text(
                widget.res.user.email ?? 'Null',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
              )),
          Divider(
            thickness: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 8),
            child: Row(
              children: <Widget>[
                Text(
                  'Saved Address',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.radio_button_checked),
                    title: Text('Home'),
                    subtitle: Text(
                      widget.res.user.address ?? 'Null',
                    ),
                    trailing: Icon(Icons.edit),
                    isThreeLine: true,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Text(
              'Cash on delivery(COD)',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Text(
              'Pay with UPI',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => openCheckout('upi'),
          ),
          ListTile(
            leading: Text(
              'NetBanking',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => openCheckout('netbanking'),
          ),
          ListTile(
            leading: Text(
              'Debit Card',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => openCheckout('card'),
          ),
          ListTile(
            leading: Text(
              'Wallets',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => openCheckout('wallet'),
          ),
        ],
      ),
    );
  }
}
