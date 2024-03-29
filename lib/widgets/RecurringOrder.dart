import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/wallet.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:intl/intl.dart';

class RecurringOrder extends StatefulWidget {
  final ProductData pro;
  const RecurringOrder({Key key, this.pro}) : super(key: key);
  @override
  _RecurringOrderState createState() => _RecurringOrderState();
}

class _RecurringOrderState extends State<RecurringOrder> {
  int _itemcounter = 1;
  DatePickerController _controller = DatePickerController();
  DateTime _startDate = DateTime.now().add(Duration(days: 1));
  DateTime _endDate = DateTime.now().add(Duration(days: 6));
  String frequency = 'daily';
  DateTime _initialendDate = DateTime.now().add(Duration(days: 6));
  List<bool> isSelected;
  @override
  void initState() {
    isSelected = [false, true, false];

    super.initState();
  }

  String message = '';
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                height: 80,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 80,
                              width: 80,
                              child: Image.network(widget.pro.imageUrl) == null
                                  ? CircularProgressIndicator()
                                  : Image.network(
                                      widget.pro.imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(child: Loader());
                                      },
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.pro.title.toString().toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.pro.baseQuantity.toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "₹" + widget.pro.gstAmount.toString()+" ",
                                         
                                          style: TextStyle(
                                            color: black,
                                          ),
                                        ),
                                        TextSpan(
                                            text: widget.pro.mrp.toStringAsFixed(1),
                                            style: TextStyle(
                                                color: grey,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _itemcounter = 0;
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Icon(
                                      Icons.replay,
                                      color: blue,
                                    )),
                              ),
                              Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blue)),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _itemcounter == 0
                                        ? Container()
                                        : InkWell(
                                            onTap: () async {
                                              setState(() {
                                                _itemcounter--;
                                              });
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              color: blue,
                                            ),
                                          ),
                                    _itemcounter == 0
                                        ? Text(
                                            'ADD',
                                            style: TextStyle(color: blue),
                                          )
                                        : Text(
                                            _itemcounter.toString(),
                                            style: TextStyle(color: blue),
                                          ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _itemcounter++;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: blue,
                                      ),
                                    ),
                                  ],
                                )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Set Frequency'),
                Text(frequency.toUpperCase())
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              // margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: ToggleButtons(
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Center(
                          child: Text(
                        'Alternative Day',
                        overflow: TextOverflow.ellipsis,
                      ))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Center(
                          child:
                              Text('Daily', overflow: TextOverflow.ellipsis))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Center(
                          child: Text('Once a Week',
                              overflow: TextOverflow.ellipsis))),
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                  switch (index) {
                    case 0:
                      setState(() {
                        frequency = "alternative";
                        _endDate = _initialendDate =
                            DateTime.now().add(Duration(days: 12));
                      });
                      break;
                    case 1:
                      setState(() {
                        frequency = "daily";
                        _endDate = _initialendDate =
                            DateTime.now().add(Duration(days: 6));
                      });
                      break;
                    case 2:
                      setState(() {
                        frequency = "once a week";
                        _endDate = _initialendDate =
                            DateTime.now().add(Duration(days: 37));
                      });
                      break;
                    default:
                      setState(() {
                        frequency = "daily";
                        _endDate = _initialendDate =
                            DateTime.now().add(Duration(days: 6));
                      });
                      break;
                  }
                },
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Select Start Date'),
                Text(
                  DateFormat.yMMMd().format(_startDate).toString(),
                  style: TextStyle(color: black),
                ),
              ],
            ),
          ),
          Container(
            child: DatePicker(
              DateTime.now().add(Duration(days: 1)),
              width: 50,
              height: 80,
              controller: _controller,
              initialSelectedDate: DateTime.now().add(Duration(days: 1)),
              selectionColor: Colors.black,
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                setState(() {
                  _startDate = date;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Select End Date'),
                Text(
                  DateFormat.yMMMd().format(_endDate).toString(),
                  style: TextStyle(color: black),
                ),
              ],
            ),
          ),
          Container(
            child: DatePicker(
              _initialendDate,
              width: 50,
              height: 80,
              controller: _controller,
              initialSelectedDate: _initialendDate,
              selectionColor: Colors.black,
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                setState(() {
                  _endDate = date;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                message,
                style: TextStyle(color: red),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              message == "Insufficient Wallet Funds !"
                  ? InkWell(
                      onTap: () => changeScreen(context, Wallet()),
                      child: Text(
                        "Add money to wallet?",
                        style: TextStyle(color: blue),
                      ))
                  : Container(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: FlatButton(
                      color: Colors.green[50],
                      onPressed: () => Navigator.pop(context),
                      child: Text('I\'ll do it later')),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                      color: Colors.green[50],
                      onPressed: () async {
                       
                        String s = await recurringOrder(
                            widget.pro.id.toString(),
                            _itemcounter.toString(),
                            DateFormat('yyyy-MM-dd')
                                .format(_startDate)
                                .toString(),
                            DateFormat('yyyy-MM-dd')
                                .format(_endDate)
                                .toString(),
                            frequency);
                        setState(() {
                          message = s;
                        });
                        if (message == "Success") {
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Set Scheduel')),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
