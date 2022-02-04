import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:intl/intl.dart';
import 'package:grocery/models/ReviewModel.dart';
import 'package:grocery/models/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class ProductDisplay extends StatefulWidget {
  final ProductData product;
  ProductDisplay(this.product);

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  TextEditingController comment = TextEditingController(text: "");
  TextEditingController rate = TextEditingController(text: "5");

  Future<List<ReviewList>> getReviews(id) async {
    debugPrint("Get Review $id");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    var response = await http.get(Uri.parse(GETPRODUCTREVIEW + "$id/reviews"),
        headers: {"Authorization": token});
    ProductReview review = ProductReview.fromJson(json.decode(response.body));
    return review.data;
  }

  postReview(comment, id, rating) async {
    debugPrint("Post Review $id $rating");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    var response = await http.post(Uri.parse(POSTREVIEW), headers: {
      "Authorization": token
    }, body: {
      "comment": comment,
      "product_id": id.toString(),
      "rating": rating.toString()
    });
    debugPrint(response.body);
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: pcolor,
          title: Text(
            widget.product.title,
            overflow: TextOverflow.ellipsis,
          )),
      body: FutureBuilder(
          future: getReviews(widget.product.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<ReviewList>> snapshot) {
            if (snapshot.data == null) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          // enabled: _enabled,
                          child: ListView.builder(
                            itemBuilder: (_, __) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60.0,
                                    height: 60.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
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
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          child: Image.network(
                            widget.product.imageUrl,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      Text("Reviews",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          maxLength: 500,
                          maxLines: 2,
                          controller: comment,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            contentPadding: EdgeInsets.all(8),
                                            title: Text("Rate this product"),
                                            children: [
                                              RatingBar.builder(
                                                initialRating: 5,
                                                minRating: 1,
                                                maxRating: 5,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  setState(() {
                                                    rate.text =
                                                        rating.toString();
                                                  });
                                                },
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    postReview(
                                                        comment.text,
                                                        widget.product.id,
                                                        rate.text);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Submit Review"))
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.send)),
                              border: OutlineInputBorder(
                                  borderSide: new BorderSide()),
                              label: Text("Write review")),
                        ),
                      ),
                      ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data.length == 0) {
                            return Text(
                              "No reviews",
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  // height: 100,
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
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data[index].user.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          RatingBarIndicator(
                                            rating: double.parse(snapshot
                                                .data[index].rating
                                                .toString()),
                                            itemBuilder: (context, index) =>
                                                Icon(
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
                                      Text(DateFormat("dd-MM-yyyy").format(
                                          DateTime.parse(
                                              snapshot.data[index].createdAt))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          snapshot.data[index].comment ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                      // RichText(
                                      //   overflow: TextOverflow.ellipsis,
                                      //   maxLines: 2,
                                      //   softWrap: true,
                                      //   textAlign: TextAlign.justify,
                                      //     text: TextSpan(
                                      //         text: snapshot.data[index].comment,
                                      //         style: TextStyle(color: pcolor)))
                                    ],
                                  )),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
