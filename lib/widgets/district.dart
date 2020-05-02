import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/widgets/existing_customer.dart';
import 'package:http/http.dart' as http;

class District extends StatefulWidget {
  final int cityId;
  District(this.cityId);
  @override
  _DistrictState createState() => _DistrictState();
}

Future<List<dynamic>> getLocation(cityId) async {
  print(AREA + cityId.toString());
  http.Response response = await http.get(AREA + cityId.toString());
  Map<String, dynamic> decodedCategories = json.decode(response.body);
  return decodedCategories['data'];
}

class _DistrictState extends State<District> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: grey,
                ),
                hintText: 'Search Location',
                border: InputBorder.none),
          ),
        ),
        backgroundColor: pcolor,
      ),
      body: FutureBuilder(
        future: getLocation(widget.cityId),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: index % 2 == 0
                            ? Colors.black26
                            : Colors.black12,
                        child: ListTile(
                          onTap: () {
                            changeScreen(
                                context,
                                ExistingCustomer(
                                  area: snapshot.data[index]['id'],
                                  cityId: widget.cityId,
                                  signup: true,
                                  title: 'SignUp',
                                ));
                          },
                          leading: Text(
                            snapshot.data[index]['title'],
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: null),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
      // body: SafeArea(
      //     child: Column(
      //       children: <Widget>[
      //         Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Container(
      //             decoration: BoxDecoration(color: white, ),
      //             child: ListTile(
      //               leading: Icon(
      //                 Icons.search,
      //                 color: grey,
      //               ),
      //               trailing: Icon(
      //                 Icons.filter_list,
      //                 color: grey,
      //               ),
      //               title: TextField(
      //                 decoration: InputDecoration(
      //                     hintText: 'Search city', border: InputBorder.none),
      //               ),
      //             ),
      //           ),
      //         ),
      //         Container(
      //           child: FutureBuilder(
      //             future: getLocation(widget.city_id),
      //             builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
      //                if (snapshot.data == null) {
      //           return Center(child: CircularProgressIndicator());
      //           }else{
      //           return ListView.builder(
      //             itemCount: snapshot.data.length,
      //             itemBuilder: (BuildContext context, int index) {
      //               return ListTile(
      //                 onTap: (){
      //                   changeScreen(context, ExistingCustomer(area:'south delhi'));
      //                 },
      //                 leading: Text(snapshot.data[index]['title']),
      //                 trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null),
      //               );
      //             });
      //           }
      //             },
      //             ),
      //         )
      //       ],
      //     )),
    );
  }
}
