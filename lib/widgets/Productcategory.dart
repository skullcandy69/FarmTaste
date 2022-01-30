import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:grocery/widgets/category.dart';
import 'package:http/http.dart' as http;

Future<List<ProductCategoryData>> productcatlist() async {
  var response = await http.get(Uri.parse(GETPRODUCT));
  ProductsCategories productsCategories =
      ProductsCategories.fromJson(json.decode(response.body));
  return productsCategories.data;
}

class ProductCategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
            future: productcatlist(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  height: MediaQuery.of(context).size.height/2,
                  child: Center(
                    child: Loader(),
                  ),
                );
              } else {
                return ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  snapshot.data[index].title,
                                  style: TextStyle(
                                      color: black, fontWeight: FontWeight.bold,fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          Categories( title: snapshot.data[index].title,id: snapshot.data[index].id,),
                        ],
                      );
                      // return Container(child: Text(snapshot.data[index].title));
                    });
              }
            },
          ),
      ],
    );
  }
}
