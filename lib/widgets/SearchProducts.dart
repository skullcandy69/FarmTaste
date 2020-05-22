import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<List<ProductData>> _getAllPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http
        .get(SEARCHPRODUCTS + search, headers: {"Authorization": token});
    Products products = Products.fromJson(json.decode(response.body));
    return products.data;
  }

  String search = '';
  bool s = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .95,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    onTap: () {
                      setState(() {
                        s = true;
                      });
                    },
                    onChanged: (val) {
                      setState(() {
                        search = val;
                      });
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: grey,
                            ),
                            onPressed: () => Navigator.of(context).pop()),
                        suffixIcon: s == true
                            ? IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () => Navigator.pop(context))
                            : null,
                        hintText: 'Search for Products',
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: _getAllPosts(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: Loader(),
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
                            height: 20,
                            // color: Colors.black12,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Search result : " +
                                        snapshot.data.length.toString() +
                                        " items",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      _listofitems(snapshot.data, context, true)
                    ],
                  );
                }
              })
        ],
      ),
    )));
  }
}

_listofitems(List<ProductData> item, BuildContext context, bool add) {
  return Container(
    height: MediaQuery.of(context).size.height * .82,
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

class DetailScreen extends StatefulWidget {
  final ProductData pro;

  const DetailScreen({Key key, this.pro}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _itemcounter;
  @override
  void initState() {
    super.initState();
    setState(() {
      _itemcounter = Provider.of<ProductModel>(context, listen: false)
          .getQuanity(widget.pro.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
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
