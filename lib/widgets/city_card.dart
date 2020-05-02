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
  http.Response response = await http.get(CITIES);
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
            style: TextStyle(color: black),
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
                    // mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.amberAccent[100]
                          : Colors.black12,
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

        // body: SafeArea(
        //     child: Container(

        // child: Column(
        //   children: <Widget>[

        //     SizedBox(
        //       height: 50,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         GestureDetector(
        //           onTap: ()=>changeScreen(context, District()),
        //                           child: Container(
        //             height: 170,
        //             width: 150,
        //             decoration: BoxDecoration(
        //                 color: white,
        //                 borderRadius: BorderRadius.all(Radius.circular(20))),
        //             child: Column(
        //               children: <Widget>[
        //                 Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Image.network(
        //                       'https://cdn.dribbble.com/users/569653/screenshots/2540009/landmark-india-gate.png'),
        //                 ),
        //                 Text('DELHI')
        //               ],
        //             ),
        //           ),
        //         ),
        //         Container(
        //           height: 170,
        //           width: 150,
        //           decoration: BoxDecoration(
        //               color: white,
        //               borderRadius: BorderRadius.all(Radius.circular(20))),
        //           child: Column(
        //             children: <Widget>[
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Image.network(
        //                     'https://cdn.clipart.email/71d068d4036585afaccfad0df9185131_gate-way-of-india-clipart_800-600.jpeg'),
        //               ),
        //               Text('MUMBAI')
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       height: 20,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         Container(
        //           height: 170,
        //           width: 150,
        //           decoration: BoxDecoration(
        //               color: white,
        //               borderRadius: BorderRadius.all(Radius.circular(20))),
        //           child: Column(
        //             children: <Widget>[

        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Image.network(
        //                     'https://cdn.dribbble.com/users/1563378/screenshots/3425902/charminar_2x_1x.png'),
        //               ),
        //               Text('PUNE')
        //             ],
        //           ),
        //         ),
        //         Container(
        //           height: 170,
        //           width: 150,
        //           decoration: BoxDecoration(
        //               color: white,
        //               borderRadius: BorderRadius.all(Radius.circular(20))),
        //           child: Column(
        //             children: <Widget>[
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Image.network(
        //                     'https://clip.cookdiary.net/sites/default/files/wallpaper/fort-clipart/295609/fort-clipart-animated-295609-6389771.jpg'),
        //               ),
        //               Text('BANGALORE')
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // )
        // ),
        );
  }
}
