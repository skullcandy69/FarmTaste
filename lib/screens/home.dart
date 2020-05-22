import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/Coupons.dart';
import 'package:grocery/screens/Refer.dart';
import 'package:grocery/screens/login.dart';
import 'package:grocery/screens/profile.dart';
import 'package:grocery/screens/subscriptionScreen.dart';
import 'package:grocery/screens/wallet.dart';
import 'package:grocery/widgets/Productcategory.dart';
import 'package:grocery/widgets/SearchProducts.dart';
import 'package:grocery/widgets/address.dart';
import 'package:grocery/widgets/card.dart';
import 'package:grocery/widgets/delivery_status.dart';
import 'package:grocery/screens/shoppingCart.dart';
import 'package:grocery/widgets/helpDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Result res;
  String mob;
  read() async {
    final prefs = await SharedPreferences.getInstance();
    print('response');
    setState(() {
      res = Result.fromJson(json.decode(prefs.getString('response')));
      mob = res.user.mobileNo;
      print(res.token);
    });
  }

  @override
  void initState() {
    super.initState();
    read();
   
    // authProvider.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return Consumer<ProductModel>(builder: (context, pro, child) {
      return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: ()=>changeScreen(context,SearchProduct()),
                          child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextField(
                  decoration: InputDecoration(
                    enabled: false,
                      icon: Icon(
                        Icons.search,
                        color: grey,
                      ),
                      hintText: 'Search for Products',
                      border: InputBorder.none),
                ),
              ),
            ),
            backgroundColor: pcolor,
            actions: <Widget>[
              InkWell(
                  onTap: () {
                    changeScreen(context, Wallet());
                  },
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 28,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5, right: 5),
                child: Stack(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: white,
                          size: 30,
                        ),
                        onPressed: () async {
                          changeScreen(context, ShoppingCart());
                        }),
                    Positioned(
                      bottom: 5,
                      left: 5,
                      child: Container(
                        height: 15,
                        width: 18,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: grey,
                                  offset: Offset(2, 2),
                                  blurRadius: 3)
                            ]),
                        child: Center(
                          child: Text(
                            pro.productlist.length.toString(),
                            style: TextStyle(
                                fontSize: 10,
                                color: red,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: Container(
                        height: 50,
                        width: 50,
                        decoration:
                            BoxDecoration(color: white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                        )),
                    title: mob == null
                        ? Text('null')
                        : Text(
                            mob,
                            style: TextStyle(fontSize: 20),
                          ),
                    onTap: () => changeScreen(context, ProfilePage(res)),
                  ),
                ),
               
                ListTile(
                  leading: Icon(Icons.add_photo_alternate),
                  title: Text('Plan'),
                 onTap: ()=>changeScreen(context, SubscriptionScreen()),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text('Wallet'),
                  onTap: () {
                    changeScreen(context, Wallet());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('View Bill'),
                ),
                ListTile(
                  leading: Icon(Icons.beach_access),
                  title: Text('Vacation'),
                ),
                Divider(
                  color: black,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('others', style: TextStyle(fontSize: 20)),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Delivery Address'),
                  onTap: () async {
                    Result re = await authprovider.getUser();
                    print(re.user.address);
                    setState(() {
                      res = re;
                    });
                    changeScreen(context, Address(res));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_offer),
                  title: Text('Offers'),
                  onTap: ()=>changeScreen(context,Coupon(amount: 0,)),
                ),
                ListTile(
                  leading: Icon(Icons.grain),
                  title: Text('Refer and Earn'),
                  onTap: ()=>changeScreen(context, ReferAndEarn(res:res)),
                ),
               
                ListTile(
                  onTap: () async {
                    print('good bye');
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    changeScreenRepacement(context, LoginScreen());
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
              ],
            ),
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              DeliveryStatus(),
              Cardwidget(),
              ProductCategoryList(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => basicContentEasyDialog(context,'Hello'),
            backgroundColor:pcolor,
            child: Text('help??'),
          ));
    });
  }
}

