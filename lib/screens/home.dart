import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/recentitems.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/screens/Coupons.dart';
import 'package:grocery/screens/Refer.dart';
import 'package:grocery/screens/login.dart';
import 'package:grocery/screens/profile.dart';
import 'package:grocery/screens/subscriptionScreen.dart';
import 'package:grocery/screens/wallet.dart';
import 'package:grocery/screens/ViewBill.dart';
import 'package:grocery/widgets/Productcategory.dart';
import 'package:grocery/widgets/SearchProducts.dart';
import 'package:grocery/widgets/address.dart';
import 'package:grocery/widgets/card.dart';
// import 'package:grocery/widgets/card.dart';
import 'package:grocery/widgets/delivery_status.dart';
import 'package:grocery/screens/shoppingCart.dart';
import 'package:grocery/widgets/helpDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Result res;
  String mob;
  read() async {
    final prefs = await SharedPreferences.getInstance();
    res = Result.fromJson(json.decode(prefs.getString('response')));

    setState(() {
      mob = res.user.mobileNo;
    });
  }

  itemCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    var response =
        await http.get(Uri.parse(UPCOMINGITEM), headers: {'authorization': token});
    if (response.statusCode == 200) {
      OntheWay items = OntheWay.fromJson(json.decode(response.body));
      // print(items.date);
      // print(items.count);
      if (items.count > 0) {
        setState(() {
          count = items.count;
          date = DateTime.parse(items.date) ?? date;
          codes = items.code;
        });
      }
    }
  }

  DateTime date = DateTime.now();
  int count = 0;
  String codes = '';
  @override
  void initState() {
    super.initState();
    read();
    itemCount();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: new Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Consumer<ProductModel>(builder: (context, pro, child) {
        return Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                onTap: () => changeScreen(context, SearchProduct()),
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
                      leading: FittedBox(
                          fit: BoxFit.fill,
                          child: Hero(
                            tag: 'user',
                            child: Container(
                                height: 50,
                                width: 50,
                                child: Image.asset('images/user.png')),
                          )),
                      title: mob == null
                          ? Text('null')
                          : Text(
                              mob,
                              style: TextStyle(fontSize: 20),
                            ),
                      onTap: () => changeScreen(context, ProfilePage()),
                    ),
                  ),

                  // ListTile(
                  //   leading: FittedBox(
                  //       fit: BoxFit.cover,
                  //       child: Hero(
                  //         tag: 'plan',
                  //         child: Container(
                  //             height: 45,
                  //             width: 45,
                  //             child: Image.asset('images/plan.png')),
                  //       )),
                  //   title: Text('Plan'),
                  //   onTap: () => changeScreen(context, SubscriptionScreen()),
                  // ),
                  ListTile(
                    leading: FittedBox(
                        fit: BoxFit.fill,
                        child: Hero(
                          tag: 'wallet',
                          child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset('images/wallet.png')),
                        )),
                    title: Text('Wallet'),
                    onTap: () {
                      changeScreen(context, Wallet());
                    },
                  ),
                  ListTile(
                    leading: FittedBox(
                        fit: BoxFit.fill,
                        child: Hero(
                          tag: 'bill',
                          child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset('images/orderhistory.png')),
                        )),
                    title: Text('View Bill'),
                    onTap: () {
                      changeScreen(context, ViewBill());
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.beach_access),
                  //   title: Text('Vacation'),
                  // ),
                  Divider(
                    color: black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('others', style: TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: FittedBox(
                        fit: BoxFit.fill,
                        child: Hero(
                          tag: 'address',
                          child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset('images/address.png')),
                        )),
                    title: Text('Delivery Address'),
                    onTap: () async {
                      changeScreen(context, Address());
                    },
                  ),
                  ListTile(
                    leading: FittedBox(
                        fit: BoxFit.fill,
                        child: Hero(
                          tag: 'offers',
                          child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset('images/offers.png')),
                        )),
                    title: Text('Offers'),
                    onTap: () => changeScreen(
                        context,
                        Coupon(
                          amount: 0,
                        )),
                  ),
                  ListTile(
                    leading: FittedBox(
                        fit: BoxFit.fill,
                        child: Hero(
                          tag: 'refer',
                          child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset('images/refer.png')),
                        )),
                    title: Text('Refer and Earn'),
                    onTap: () => changeScreen(context, ReferAndEarn(res: res)),
                  ),

                  ListTile(
                    onTap: () async {
                      print('good bye');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      pro.clearList();
                      changeScreenRepacement(context, LoginScreen());
                    },
                    leading: FittedBox(
                        fit: BoxFit.fill,
                        child: Container(
                            height: 40,
                            width: 40,
                            child: Image.asset('images/logout.png'))),
                    title: Text('Logout'),
                  ),
                ],
              ),
            ),
            body: Container(
              height: size.height,
              width: size.width,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      DeliveryStatus(count: count, date: date, codes: codes),
                      Cardwidget(),
                      ProductCategoryList(),
                      SizedBox(height: 50,)
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => basicContentEasyDialog(context, """Hello,
I have issue/query regarding my order"""),
              backgroundColor: pcolor,
              child: AutoSizeText(
                'Help',
                maxLines: 1,
              ),
            ));
      }),
    );
  }
}
