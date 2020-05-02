import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Cardwidget extends StatefulWidget {
  @override
  _CardwidgetState createState() => _CardwidgetState();
}

class _CardwidgetState extends State<Cardwidget> {
  List<String> links = [
    'https://edenrobe.com/wp-content/uploads/WBWB.jpg',
    'https://cdn2.desidime.com/topics/photos/627730/original/39094252hycs8w.png?1484857317',
    'https://asset22.ckassets.com/resources/image/staticpage_images/Grocery-Mobile-28May2019-1562839664.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: links.length,
        autoPlay: true,
        itemBuilder: (context, index) => _buildListItem(context, links[index]));
  }
}

_buildListItem(BuildContext context, document) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: document == null
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Image.network(
              document,
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
