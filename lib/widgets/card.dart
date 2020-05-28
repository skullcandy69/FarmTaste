import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/CoverImages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Cardwidget extends StatefulWidget {
  @override
  _CardwidgetState createState() => _CardwidgetState();
}

class _CardwidgetState extends State<Cardwidget> {
  List<ImageData> list;
  bool isLoading = true;
  getCoverImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(GETIMAGES, headers: {"Authorization": token});
    print(response.body);
    if (response.statusCode == 200) {
      CoverImages coverImages =
          CoverImages.fromJson(json.decode(response.body));
      setState(() {
        list = coverImages.data;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCoverImages();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        height: 200,
        itemCount: isLoading ? 0 : list.length,
        autoPlay: true,
        itemBuilder: (context, index) {
          if (isLoading == true) {
            return Card(
              child: Container(
                height: 200,
                child: Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(color: grey),
                  ),
                ),
              ),
            );
          } else {
            return _buildListItem(context, list[index]);
          }
        });
  }
}

_buildListItem(BuildContext context, ImageData document) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: document == null
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Image.network(
              BASE_URL + "/" + document.imageUrl,
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
    ),
  );
}
