import 'dart:convert';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/screens/ProductDetails.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/products.dart';

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
              child: Center(
                child: Loader(),
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
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 80,
                            width: 120,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green[100],
                                  blurRadius: 5.0, 
                                 
                                  offset: Offset(
                                    -3.0,
                                    3.0, 
                                  ),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapshot.data[index].imageUrl,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text(
                            snapshot.data[index].title,
                            style: TextStyle(
                                color: black, fontWeight: FontWeight.w400),
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
