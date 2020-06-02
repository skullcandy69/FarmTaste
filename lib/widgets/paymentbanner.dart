import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';

class Bannerpayment extends StatelessWidget {
  final bool status;
  const Bannerpayment({Key key, this.status});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
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
                  AutoSizeText(
                    'Order Summary',
                    style: TextStyle(fontSize: 15,color: grey),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Center(
                  child:Divider(thickness: 5,)
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
                        child: AutoSizeText(
                      '2',
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
                  ),
                  AutoSizeText(
                    'Address',
                    style: TextStyle(fontSize: 15,color: grey),
                  )
                ],
              ), Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child:Divider(thickness: 5,)
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                        color: green, borderRadius: BorderRadius.circular(50)),
                    child: Center(
                        child: AutoSizeText(
                      '3',
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
                  ),
                  AutoSizeText(
                    'Payments',
                    style: TextStyle(fontSize: 15,color: grey),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
