import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';

class DeliveryStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Text('0',style: new TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 40)),
            SizedBox(width: 10,),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: 'items to be delivered tomorrow \n',
                  style: new TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 18)),
              TextSpan(
                  text: 'Saturday , 11th april 2020',
                  style: new TextStyle( color: grey))
            ])),
          ],
        ),
      ),
    );
  }
}
