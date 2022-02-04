import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/Product.dart';
import 'package:grocery/screens/shoppingCart.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/RecurringOrder.dart';
import 'package:grocery/widgets/SearchProducts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetails extends StatefulWidget {
  final int id;
  final String title;
  final String head;
  final List<ProductSubCategoryData> productsubcat;
  ProductDetails({this.id, this.title, this.head, this.productsubcat});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

Future<List<ProductData>> productcatlist(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response = await http.get(Uri.parse(GETSUBPRODUCATCAT + id),
      headers: {"Authorization": token});
  // print(token);
  Products products = Products.fromJson(json.decode(response.body));
  return products.data;
}

class _ProductDetailsState extends State<ProductDetails> {
  bool add = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductModel>(builder: (context, pro, child) {
      return DefaultTabController(
          length: widget.productsubcat.length,
          initialIndex: widget.id,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: pcolor,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      changeScreen(context, SearchProduct());
                    }),
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
              title: Text(widget.head.toUpperCase()),
              bottom: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                indicatorColor: white,
                tabs: List<Widget>.generate(widget.productsubcat.length,
                    (int index) {
                  return new Tab(
                      text: widget.productsubcat[index].title.toUpperCase());
                }),
              ),
            ),
            body: TabBarView(
                children: List<Widget>.generate(widget.productsubcat.length,
                    (int index) {
              return FutureBuilder(
                  future:
                      productcatlist(widget.productsubcat[index].id.toString()),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Shimmer.fromColors(
                                baseColor: Colors.lightGreen[100],
                                highlightColor: Colors.grey[100],
                                // enabled: _enabled,
                                child: ListView.builder(
                                  itemBuilder: (_, __) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60.0,
                                          height: 60.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: 40.0,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  itemCount: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      int len = pro.getProductList().length;
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          ListView(
                            children: <Widget>[
                              _listofitems(snapshot.data, context, add, len),
                            ],
                          ),
                          len != 0
                              ? Positioned(
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: grey,
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 2.0,
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
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Total Amount: ',
                                                    style: TextStyle(
                                                        color: grey,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                TextSpan(
                                                    text: '₹' +
                                                        pro.tprice
                                                            .toStringAsFixed(1),
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400))
                                              ]),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FlatButton(
                                                onPressed: () async {
                                                  // _timer.cancel();
                                                  // Timer(Duration(seconds: 2),()=>)
                                                  changeScreenRepacement(
                                                      context, ShoppingCart());
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Checkout',
                                                    style:
                                                        TextStyle(color: white),
                                                  ),
                                                ),
                                                color: Colors.deepOrange,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              : Container()
                        ],
                      );
                    }
                  });
            })),
          ));
    });
  }

  _listofitems(
      List<ProductData> item, BuildContext context, bool add, int len) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: item.length + 1,
        itemBuilder: (BuildContext context, int index) {
          print(item.length);
          if (index == item.length) {
            return SizedBox(
              height: 50,
            );
          } else {
            return DetailScreen(
              pro: item[index],
            );
          }
        },
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final ProductData pro;

  const DetailScreen({Key key, this.pro}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _itemcounter = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _itemcounter = Provider.of<ProductModel>(context, listen: false)
          .getQuanity(widget.pro.id);
    });
  }

  void _showDialog(ProductData product) {
    slideDialog.showSlideDialog(
      context: context,
      child: RecurringOrder(
        pro: product,
      ),
      pillColor: Colors.red,
      backgroundColor: white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                color: Colors.grey[350],
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () {
                            changeScreen(context, ProductDisplay(widget.pro));
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            child: Image.network(widget.pro.imageUrl) == null
                                ? CircularProgressIndicator()
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        widget.pro.imageUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(child: Loader());
                                        },
                                      ),
                                      widget.pro.inStock
                                          ? Container()
                                          : Image.asset(
                                              'images/outofstock.png',
                                              fit: BoxFit.contain,
                                              // color: Colors.white,
                                              // colorBlendMode: BlendMode.darken,
                                            )
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                widget.pro.title.toString().toUpperCase(),
                                maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                              ),
                              AutoSizeText(
                                widget.pro.baseQuantity.toString(),
                                maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "₹" +
                                          widget.pro.gstAmount.toString() +
                                          ' ',
                                      style: TextStyle(
                                        color: black,
                                      ),
                                    ),
                                    TextSpan(
                                        text: widget.pro.mrp.toStringAsFixed(1),
                                        style: TextStyle(
                                            color: grey,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                  ],
                                ),
                              ),
                              RatingBarIndicator(
                                rating:
                                    double.parse(widget.pro.rating.toString()),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: pcolor,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                unratedColor: Colors.black12,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ),
                      ),
                      widget.pro.inStock == false
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                // GestureDetector(
                                //   onTap: () => widget.pro.inStock
                                //       ? _showDialog(widget.pro)
                                //       : Scaffold.of(context)
                                //           .showSnackBar(SnackBar(
                                //           content: Text("OUT OF STOCK"),
                                //           backgroundColor: red,
                                //         )),
                                //   child: Container(
                                //       decoration: BoxDecoration(
                                //           color: white,
                                //           borderRadius:
                                //               BorderRadius.circular(50)),
                                //       child: Icon(
                                //         Icons.replay,
                                //         color: blue,
                                //       )),
                                // ),
                                Container(
                                  height: 30,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: pcolor)),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _itemcounter == 0
                                          ? Container()
                                          : InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  _itemcounter--;
                                                });
                                                Provider.of<ProductModel>(
                                                        context,
                                                        listen: false)
                                                    .removeItem(widget.pro);
                                                await addToCart(widget.pro.id,
                                                    _itemcounter);
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                color: pcolor,
                                              ),
                                            ),
                                      _itemcounter == 0
                                          ? Text(
                                              'ADD',
                                              style: TextStyle(color: pcolor),
                                            )
                                          : Text(
                                              _itemcounter.toString(),
                                              style: TextStyle(color: pcolor),
                                            ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _itemcounter++;
                                          });
                                          Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .addTaskInList(widget.pro);

                                          if (await addToCart(
                                              widget.pro.id, _itemcounter)) {
                                            // _scaffoldKey.currentState.showSnackBar(
                                            //     new SnackBar(
                                            //         content: new Text(
                                            //             'Added ${widget.pro.title} to cart')));
                                          }
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: pcolor,
                                        ),
                                      ),
                                    ],
                                  )),
                                )
                              ],
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
