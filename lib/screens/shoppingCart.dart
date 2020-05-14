import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/Coupons.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/checkout.dart';
import 'package:http/http.dart'as http;

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool isLoading = false;

  _buildCartItem(order) {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 120.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                order.imageUrl == null
                    ? Container(
                        height: 80,
                        width: 80,
                      )
                    : Container(
                        width: 80.0,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(order.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          order.title.toString().toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(order.rate.toString())
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        color: red,
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          print(order.productId);
                          setState(() {
                            deletCartItem(order.productId.toString());
                          });
                        }),
                    Container(
                      height: 30,
                      width: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                order.noOfUnits > 0
                                    ? updateCart(order.productId.toString(),
                                        order.noOfUnits - 1)
                                    : print('item 0');
                              });
                            },
                            child: Container(
                                height: 25,
                                width: 25.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 0.8,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                          ),
                          // SizedBox(width: 20.0),
                          Text(
                            order.noOfUnits.toString(),
                          ),
                          // SizedBox(width: 20.0),

                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              print('add');

                              setState(() {
                                updateCart(order.productId.toString(),
                                    order.noOfUnits + 1);
                              });
                            },
                            child: Container(
                                height: 25,
                                width: 25.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 0.8,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController _coupon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: pcolor,
      ),
      body: FutureBuilder(
          future: myCart(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Container(child: Loader()),
              );
            } else {
              return ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.data.products.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < snapshot.data.data.products.length) {
                          return _buildCartItem(
                              snapshot.data.data.products[index]);
                        } else if (snapshot.data.data.amount != 0) {
                          return Container(
                            height: MediaQuery.of(context).size.height * .25,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.black12,
                                  child: Center(child: Text('PRICE DETAILS')),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          'Price(${snapshot.data.data.products.length} items)'),
                                      Text('₹' +
                                          snapshot.data.data.amount.toString())
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Delivery fee'),
                                      Text("+ ₹" +
                                          snapshot.data.data.deliveryCharge
                                              .toString())
                                    ],
                                  ),
                                ),
                                snapshot.data.data.couponCode == null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            left: 10.0,
                                            right: 10,
                                            bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                            
                                                changeScreen(context, Coupon(amount:snapshot.data.data.amount));
                                              },
                                              child: Container(
                                                child: Text(
                                                  "Apply Coupon",
                                                  style: TextStyle(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            left: 10.0,
                                            right: 10,
                                            bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Coupon:  " +
                                                snapshot.data.data.couponCode),
                                            InkWell(
                                              onTap: () async{
                                               var res =await http.put(REMOVECOUPON);
                                               print(res.body);
                                              },
                                              child: Container(
                                                child: Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                snapshot.data.data.couponCode == null
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Discount '),
                                            Text('- ₹' +
                                                snapshot.data.data.discount
                                                    .toString())
                                          ],
                                        ),
                                      ),
                                Divider(
                                  color: black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 10.0,
                                      right: 10,
                                      bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Total Amount'),
                                      Text('₹' +
                                          (snapshot.data.data.amount +
                                                  snapshot.data.data
                                                      .deliveryCharge -
                                                  snapshot.data.data.discount)
                                              .toStringAsFixed(2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Container(
                              height: 500,
                              child: Image.asset(
                                'images/emptycart.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  snapshot.data.data.amount != 0
                      ? Container(
                          height: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(1.0, 6.0),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 10, left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: '₹' +
                                            (snapshot.data.data.amount +
                                                    snapshot.data.data
                                                        .deliveryCharge -
                                                    snapshot.data.data.discount)
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400))
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    onPressed: () async {
                                      changeScreenRepacement(
                                          context,
                                          Checkout(
                                              cart: snapshot.data.data,
                                              totalamount:
                                                  (snapshot.data.data.amount +
                                                      snapshot.data.data
                                                          .deliveryCharge),
                                              amount:
                                                  snapshot.data.data.amount));
                                    },
                                    child: Center(
                                      child: Text(
                                        'Checkout',
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                    color: Colors.deepOrange,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            }
          }),
    );
  }
}
