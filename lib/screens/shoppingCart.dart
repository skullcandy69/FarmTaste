import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/payments/paymentScreen.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  _buildCartItem(order) {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 120.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(order.product.imageUrl),
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
                          order.product.title.toString().toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: order.product.rate[0].discountedAmount !=
                                        null
                                    ? "₹${order.product.rate[0].discountedAmount.toString()}\t"
                                    : "₹${order.product.rate[0].baseAmount.toString()}\t",
                                style: TextStyle(
                                  color: black,
                                ),
                              ),
                              TextSpan(
                                  text: order.product.rate[0]
                                              .discountedAmount !=
                                          null
                                      ? "₹${order.product.rate[0].baseAmount.toString()}"
                                      : '',
                                  style: TextStyle(
                                      color: grey,
                                      decoration: TextDecoration.lineThrough)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        color: red, icon: Icon(Icons.delete), onPressed: () {
                         setState(() {
                            deletCartItem(order.id.toString());
                         });
                        }),
                    Container(
                      height: 30,
                      width: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        // border: Border.all(
                        //   width: 0.8,
                        //   color: Colors.black54,
                        // ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                updateCart(
                                    order.id.toString(), order.noOfUnits - 1);
                              });
                              ShoppingCart();
                              setState(() {
                                updateCart(
                                    order.id.toString(), order.noOfUnits - 1);
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
                            onTap: () {
                              print('add');

                              setState(() {
                                updateCart(
                                    order.id.toString(), order.noOfUnits + 1);
                              });
                              ShoppingCart();
                              setState(() {
                                updateCart(
                                    order.id.toString(), order.noOfUnits + 1);
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
                child: Container(
                  height: 400,
                  child: Image.network(
                    'https://tyjara.com/assets/site/img/empty-cart.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data[0].length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < snapshot.data[0].length) {
                          return _buildCartItem(snapshot.data[0][index]);
                        }
                        return Container(
                          height: MediaQuery.of(context).size.height * .2,
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
                                        'Price(${snapshot.data[0].length} items)'),
                                    Text('₹' + snapshot.data[1].toString())
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Delivery fee'),
                                    Text('₹50 ')
                                  ],
                                ),
                              ),
                              Divider(
                                color: black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Total Amount'),
                                    Text('₹' +
                                        (snapshot.data[1] + 50)
                                            .toStringAsFixed(2))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
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
                      padding: const EdgeInsets.only(right: 10, left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: '₹' +
                                      (snapshot.data[1] + 50)
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String res = prefs.getString('response');
                                Result r = Result.fromJson(json.decode(res));
                                print(r.user.address);
                                changeScreen(
                                    context,
                                    PaymentScreen(
                                      res: r,
                                      cart: snapshot.data[0],
                                      totalamount: (snapshot.data[1] + 50),
                                    ));
                              },
                              child: Center(
                                child: Text(
                                  'Place Order',
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
                ],
              );
            }
          }),
    );
  }
}
