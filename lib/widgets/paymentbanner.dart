import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';

class Bannerpayment extends StatelessWidget {
  final bool status;
  const Bannerpayment({Key key, this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(
          10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  color: green,
                  size: 30,
                ),
                Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 15,color: grey),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Center(
                child: Container(
                  height: 1.0,
                  width: 50.0,
                  color: Colors.black,
                ),
              ),
            ),
            Column(
              children: <Widget>[
              status? Icon(
                  Icons.check_circle,
                  color: green,
                  size: 30,
                ):Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: Text(
                    '2',
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )),
                ),
                Text(
                  'Address',
                  style: TextStyle(fontSize: 15,color: grey),
                )
              ],
            ), Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Container(
                height: 1.0,
                width: 50.0,
                color: Colors.black,
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: Text(
                    '3',
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )),
                ),
                Text(
                  'Payments',
                  style: TextStyle(fontSize: 15,color: grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
