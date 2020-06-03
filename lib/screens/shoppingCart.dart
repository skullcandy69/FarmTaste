import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/Coupons.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/checkout.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool isLoading = true;
  CartItem myitem;

  Timer _timer;
  fetchCart() async {
    CartItem c = await myCart();
    setState(() {
      myitem = c;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _timer =Timer.periodic(Duration(seconds: 1), (Timer t) => fetchCart());
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    return Scaffold(
        appBar: AppBar(
          title: Text('Shopping Cart'),
          backgroundColor: pcolor,
        ),
        body: isLoading
            ? Container(child: Center(child: Loader()))
            : Consumer<ProductModel>(
                builder: (context, cart, child) {
                  return ListView(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * .80,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: cart.getProductList().length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < cart.getProductList().length) {
                              return BuildCart(
                                  order: cart.getProductList()[index]);
                            } else if (cart.tprice != 0) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * .35,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.black12,
                                      child:
                                          Center(child: Text('PRICE DETAILS')),
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
                                              'Price(${cart.productlist.length} items)'),
                                          Text('₹' +
                                              cart.tprice.toStringAsFixed(2))
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
                                              myitem.data.deliveryCharge
                                                  .toString())
                                        ],
                                      ),
                                    ),
                                    myitem.data.couponCode == null
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
                                                    setState(() {
                                                      changeScreen(
                                                          context,
                                                          Coupon(
                                                              amount:
                                                                  cart.tprice));
                                                    });
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Coupon:  " +
                                                    myitem.data.couponCode),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {});
                                                    await http.put(REMOVECOUPON,
                                                        headers: {
                                                          "Authorization": token
                                                        });
                                                    setState(() {
                                                      myCart();
                                                    });
                                                    // print(res.body);
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
                                    myitem.data.couponCode == null
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text('Discount '),
                                                Text('- ₹' +
                                                    myitem.data.discount
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
                                              (cart.tprice +
                                                      myitem
                                                          .data.deliveryCharge -
                                                      myitem.data.discount)
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
                      cart.tprice != 0
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
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: '₹' +
                                                (cart.tprice +
                                                        myitem.data
                                                            .deliveryCharge -
                                                        myitem.data.discount)
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
                                                  cart: myitem.data,
                                                  totalamount: (cart.tprice +
                                                      myitem
                                                          .data.deliveryCharge -
                                                      myitem.data.discount),
                                                  amount: cart.tprice));
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
                },
              ));
  }
}

class BuildCart extends StatefulWidget {
  final ProductData order;

  const BuildCart({Key key, this.order});

  @override
  _BuildCartState createState() => _BuildCartState();
}

class _BuildCartState extends State<BuildCart> {
  int quantity;
  final car = ShoppingCart();
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductModel>(
      builder: (context, cart, child) {
        quantity = cart.getQuanity(widget.order.id);
        return Container(
          padding: EdgeInsets.all(20.0),
          height: 120.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 15.0,
                color: Colors.grey[350],
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    widget.order.imageUrl == null
                        ? Container(
                            height: 80,
                            width: 80,
                          )
                        : Container(
                            width: 80.0,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.order.imageUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.order.title.toString().toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.order.baseQuantity.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("₹" + getGstPrice(widget.order))
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
                              // print(widget.order.id);
                              Provider.of<ProductModel>(context, listen: false)
                                  .removeProduct(widget.order);
                              setState(() {
                                deletCartItem(widget.order.id.toString());
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
                                  Provider.of<ProductModel>(context,
                                          listen: false)
                                      .removeItem(widget.order);
                                  setState(() {
                                    quantity > 0
                                        ? updateCart(widget.order.id.toString(),
                                            quantity - 1)
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
                                quantity.toString(),
                              ),
                              // SizedBox(width: 20.0),

                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  print('add');

                                  Provider.of<ProductModel>(context,
                                          listen: false)
                                      .addTaskInList(widget.order);
                                  setState(() {
                                    updateCart(widget.order.id.toString(),
                                        quantity + 1);
                                  });
                                  car.createState();
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
      },
    );
  }
}
