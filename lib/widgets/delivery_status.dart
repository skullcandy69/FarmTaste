import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:intl/intl.dart';

class DeliveryStatus extends StatefulWidget {
  final int count;
  final DateTime date;
  final String codes;
  const DeliveryStatus({Key key, this.count, this.date, this.codes});

  @override
  _DeliveryStatusState createState() => _DeliveryStatusState();
}

class _DeliveryStatusState extends State<DeliveryStatus> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Text(widget.count.toString(),
                      style: new TextStyle(
                          fontWeight: FontWeight.w400,
                          color: black,
                          fontSize: 40)),
                  SizedBox(width: MediaQuery.of(context).size.width * .02),
                  RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: 'items to be delivered on \n',
                            style: new TextStyle(
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontSize: 18)),
                        TextSpan(
                            text: DateFormat.yMMMEd()
                                .format(widget.date)
                                .toString(),
                            style: new TextStyle(color: grey))
                      ])),
                ],
              ),
              Text('Code\n'+widget.codes.toUpperCase())
              // Container(
              //   width: 100,
              //   child: DropdownButtonFormField(
              //     // autovalidate: true,
              //     items: widget.codes.map((Codes code) {
              //       return DropdownMenuItem<Codes>(
              //           value: code,
              //           child: AutoSizeText(
              //               code.orderId.toString().toUpperCase(),maxLines: 1,
              //               style: TextStyle(fontSize: 15)));
              //     }).toList(),
              //     value: selectedValue,
              //     onChanged: (value) {
              //       setState(() {
              //         selectedValue = value;
              //         print('changed' + selectedValue.orderId.toString());
              //         // areaid = selectedValue.id.toString();
              //       });
              //     },
              //     validator: (value) {
              //       if (value == null) {
              //         return 'please select a location';
              //       }
              //       return null;
              //     },
              //     isExpanded: true,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
