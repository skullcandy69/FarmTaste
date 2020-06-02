import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/screens/ProductDetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/products.dart';
import 'package:shimmer/shimmer.dart';

Future<List<ProductSubCategoryData>> productsubcatlist(String id) async {
  var response = await http.get(GETPARTICULARPRODUCATCAT + id);
  // print('hello');

  ProductSubCategory productSubCategory =
      ProductSubCategory.fromJson(json.decode(response.body));
  // print(productSubCategory.data[1].title);
  return productSubCategory.data;
}

class Categories extends StatelessWidget {
  final int id;
  final String title;
  
  Categories({this.title, this.id});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: productsubcatlist(id.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, ),
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Shimmer.fromColors(
                                baseColor: Colors.lightGreen[100],
                                highlightColor: Colors.grey[100],
                                // enabled: _enabled,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, __) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                          width: 120.0,
                                          height: 80.0,
                                          color: Colors.white,
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
            return Container(
              height: 120,
              // width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => changeScreen(
                          context,
                          ProductDetails(
                              head: title,
                              id: index,
                              title: snapshot.data[index].title,
                              productsubcat: snapshot.data)),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Image.network(
                              snapshot.data[index].imageUrl,
                              height: 80,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              snapshot.data[index].title,
                              style: TextStyle(
                                  color: black, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
