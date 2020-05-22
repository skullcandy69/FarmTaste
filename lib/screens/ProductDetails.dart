import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/shoppingCart.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/RecurringOrder.dart';
import 'package:grocery/widgets/SearchProducts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class ProductDetails extends StatefulWidget {
  final int id;
  final String title;
  final String head;
  final List<ProductSubCategoryData> productsubcat;
  ProductDetails({this.id, this.title, this.head, this.productsubcat});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

Future<List<ProductData>> productcatlist(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var response =
      await http.get(GETSUBPRODUCATCAT + id, headers: {"Authorization": token});
  // print('products');
  Products products = Products.fromJson(json.decode(response.body));
  // print('products:' + products.data[1].title);
  return products.data;
}

class _ProductDetailsState extends State<ProductDetails> {
  bool add = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.productsubcat.length,
        initialIndex: widget.id,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: pcolor,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    changeScreen(context, SearchProduct());
                  })
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
                          horizontal: 16.0, vertical: 16.0),
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
                    int len = Provider.of<ProductModel>(context)
                        .getProductList()
                        .length;
                    return ListView(
                      children: <Widget>[
                        _listofitems(snapshot.data, context, add, len),
                        len == 0
                            ? Container()
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * .068,
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
                                              text: 'Total Amount: ₹' +
                                                  Provider.of<ProductModel>(
                                                          context)
                                                      .tprice
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
                                            changeScreen(
                                                context, ShoppingCart());
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
                      ],
                    );
                  }
                });
          })),
        ));
  }

  _listofitems(
      List<ProductData> item, BuildContext context, bool add, int len) {
    return Container(
      height: len == 0
          ? MediaQuery.of(context).size.height * .8
          : MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: item.length,
        itemBuilder: (BuildContext context, int index) {
          return DetailScreen(
            pro: item[index],
          );
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
          height: 80,
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
                      GestureDetector(
                        onTap: () => _showDialog(widget.pro),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 80,
                            width: 80,
                            child: Image.network(widget.pro.imageUrl) == null
                                ? CircularProgressIndicator()
                                : Image.network(
                                    widget.pro.imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(child: Loader());
                                    },
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
                              Text(
                                widget.pro.title.toString().toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                              ),
                             
                              Text(
                                widget.pro.baseQuantity.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                             
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.pro.rate[0]
                                                  .discountedAmount !=
                                              null
                                          ? "₹${widget.pro.rate[0].discountedAmount.toString()}\t"
                                          : "₹${widget.pro.rate[0].baseAmount.toString()}\t",
                                      style: TextStyle(
                                        color: black,
                                      ),
                                    ),
                                    TextSpan(
                                        text: widget.pro.rate[0]
                                                    .discountedAmount !=
                                                null
                                            ? "₹${widget.pro.rate[0].baseAmount.toString()}"
                                            : '',
                                        style: TextStyle(
                                            color: grey,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Provider.of<ProductModel>(context, listen: false)
                                  .removeProduct(widget.pro);
                              setState(() {
                                _itemcounter = 0;
                                deletCartItem(widget.pro.id.toString());
                              });
                            },
                            child: Container(
                                // color: white,
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.replay,
                                  color: blue,
                                )),
                          ),
                          Container(
                            height: 30,
                            width: 75,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blue)),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _itemcounter == 0
                                    ? Container()
                                    : InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _itemcounter--;
                                          });
                                          Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .removeItem(widget.pro);
                                          await addToCart(
                                              widget.pro.id, _itemcounter);
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: blue,
                                        ),
                                      ),
                                _itemcounter == 0
                                    ? Text(
                                        'ADD',
                                        style: TextStyle(color: blue),
                                      )
                                    : Text(
                                        _itemcounter.toString(),
                                        style: TextStyle(color: blue),
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
                                    color: blue,
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
