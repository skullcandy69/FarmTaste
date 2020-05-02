import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CollectionScaleTransition(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                color: pcolor, borderRadius: BorderRadius.circular(50)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                color: pcolor, borderRadius: BorderRadius.circular(50)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                color: pcolor, borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ],
    );
  }
}
