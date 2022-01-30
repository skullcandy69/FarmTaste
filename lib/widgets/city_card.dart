import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/widgets/district.dart';
import 'package:http/http.dart' as http;

class City extends StatefulWidget {
  @override
  _CityState createState() => _CityState();
}

Future<List<dynamic>> getCity() async {
  http.Response response = await http.get(Uri.parse(CITIES));
  Map<String, dynamic> decodedCategories = json.decode(response.body);
  return decodedCategories['data'];
}

class _CityState extends State<City> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select City',
          ),
          backgroundColor: pcolor,
        ),
        body: FutureBuilder(
          future: getCity(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => changeScreenRepacement(
                              context, District(snapshot.data[index]['id'])),
                          child: GridTile(
                            footer: Center(
                                child: new Text(
                              snapshot.data[index]['title'],
                              style: TextStyle(fontSize: 18),
                            )),
                            child: Container(
                              height: 50,
                              child: Image.network(
                                          snapshot.data[index]['image_url']) ==
                                      null
                                  ? CircularProgressIndicator()
                                  : Image.network(
                                      snapshot.data[index]['image_url'],
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        )

       
        );
  }
}
