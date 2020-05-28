import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:intl/intl.dart';

class DeliveryStatus extends StatelessWidget {
  final int count;
  final DateTime date;

  const DeliveryStatus({Key key, this.count, this.date}) ;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Text(count.toString(),style: new TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 40)),
            SizedBox(width: 10,),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: 'items to be delivered on \n',
                  style: new TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 18)),
              TextSpan(
                  text: DateFormat.yMMMEd().format(date).toString(),
                  style: new TextStyle( color: grey))
            ])),
          ],
        ),
      ),
    );
  }
}
