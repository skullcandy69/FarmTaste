import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderSuccess extends StatefulWidget {
  final dynamic deliveryCharge;
  final dynamic discount;

  OrderSuccess({Key key, this.deliveryCharge, this.discount}) : super(key: key);

  @override
  _OrderSuccessState createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Consumer<ProductModel>(
          builder: (context, pro, child) {
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    "Order Successful",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .merge(TextStyle(letterSpacing: 1.3)),
                  ),
                ),
                body: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Colors.green.withOpacity(1),
                                          Colors.green.withOpacity(0.2),
                                        ])),
                                child: Icon(
                                  Icons.check,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  size: 90,
                                ),
                              ),
                              Positioned(
                                right: -30,
                                bottom: -50,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -20,
                                top: -50,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          Opacity(
                            opacity: 0.4,
                            child: Text(
                              "Your Order Has Been Successfully Submitted",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .merge(
                                      TextStyle(fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 255,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, -2),
                                  blurRadius: 5.0)
                            ]),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "SubTotal",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Text("₹" +  pro.tprice.toStringAsFixed(3))
                                ],
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Delivery Fee",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Text("+₹" + widget.deliveryCharge.toString())
                                ],
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Discount",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Text("-₹" + widget.discount.toString() )
                                ],
                              ),
                              Divider(height: 30),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Total",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  Text("₹" +( pro.tprice + widget.deliveryCharge - widget.discount ).toStringAsFixed(3))
                                ],
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: RoundedLoadingButton(
                                  controller: _btnController,
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                   String token = prefs.getString('token');
                                    pro.clearList();
                                    await http.delete(EMPTYCART,
                                        headers: {"Authorization": token});
                                    changeScreenRepacement(context, HomePage());
                                  },
                                  color: green,
                                  child: Text(
                                    "Continue Shopping",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ));
          },
        ));
  }
}
