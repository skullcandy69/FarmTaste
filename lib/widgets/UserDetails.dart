import 'package:flutter/material.dart';
import 'package:grocery/widgets/checkout.dart';


class PageV extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: PageController(
          initialPage: 0
        ),
        children: <Widget>[
         Checkout(),
         
        ],
      ),
    );
  }
}