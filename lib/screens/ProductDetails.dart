import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

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
  print('products');
  Products products = Products.fromJson(json.decode(response.body));
  print('products:' + products.data[1].title);
  return products.data;
}

class _ProductDetailsState extends State<ProductDetails> {
  bool add = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.productsubcat.length,
      initialIndex: widget.id,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: pcolor,
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
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 40,
                              color: Colors.black12,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.length.toString() +
                                          " items",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.filter_list),
                                      onPressed: null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _listofitems(snapshot.data, context, add)
                      ],
                    );
                  }
                });
          }))),
    );
  }

  _listofitems(List<ProductData> item, BuildContext context, bool add) {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
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
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 120,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
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
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                          widget.pro.title.toString().toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                        ),  SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.pro.rate[0].discountedAmount !=
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
                                      decoration: TextDecoration.lineThrough)),
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
                            setState(() {
                              _itemcounter = 0;
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
                          height: 25,
                          width: 65,
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
                                      onTap: () {
                                        setState(() {
                                          _itemcounter--;
                                        });
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
                                      .addTaskInList(
                                          widget.pro, _itemcounter);

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
    );
  }
}
