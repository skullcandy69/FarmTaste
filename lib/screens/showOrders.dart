import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/History.dart';
import 'package:grocery/widgets/helpDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:intl/intl.dart';


class Invoice extends StatefulWidget {
  const Invoice({Key key}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  String assetPDFPath = "";
  PdfController _pdfController;
  
  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openFile(
          '/storage/emulated/0/Android/data/com.farmtaste.grocery/files/Invoice.pdf'),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        scrollDirection: Axis.vertical,
        controller: _pdfController,
       
      ),
    );
  }
}

class ShowOrders extends StatefulWidget {
  final HistoryData order;
  final VoidCallback fun;
  ShowOrders({this.order, this.fun});

  @override
  _ShowOrdersState createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String message = 'Cancel Order';

  bool downloading = false;
  var progressString = "";

  Future<void> downloadFile() async {
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
  //  await SimplePermissions.requestPermission(Permission. WriteExternalStorage);

    try {
      // permissionResult == PermissionStatus.authorized;
      var dir = await getExternalStorageDirectory();

      await dio.download(
        GETINVOICE + widget.order.id.toString(),
        "${dir.path}/Invoice.pdf",
        options: Options(headers: {"Authorization": token}),
        onReceiveProgress: (rec, total) {
          print("${dir.path}/Invoice.pdf");
          setState(() {
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        },
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    changeScreen(context, Invoice());
  }

  Future<void> updateOrder(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    var response = await http.put(Uri.parse(ORDERS + "\/$id"),
        headers: {"Authorization": token}, body: {"order_status": "cancelled"});
    if (response.statusCode == 200) {
      _btnController.success();
      Timer(Duration(seconds: 3), () {
        widget.fun();
        Navigator.pop(context);
      });
    } else {
      setState(() {
        message = json.decode(response.body)['message'];
      });
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: pcolor,
          title: Text('Order Details'),
        ),
        body: Container(
            child: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              Divider(
                thickness: 7,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Order Id - " + widget.order.orderId.toString(),
                      style: TextStyle(fontSize: 15, color: grey),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Order Status'),
                    Text(widget.order.orderStatus)
                  ],
                ),
              )
            ],
          ),
          ExpansionTile(
            title: Text('View all Products'),
            initiallyExpanded: false,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .70,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.order.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 80,
                                width: 90,
                                child: Image.network(
                                  widget.order.products[index].imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        widget.order.products[index].title
                                            .toString()
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("₹" +
                                          widget.order.products[index].rate
                                              .toStringAsFixed(1))
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // margin: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        '${widget.order.products[index].noOfUnits.toString()} Quantity',
                                        style: TextStyle(color: grey),
                                      ),
                                      AutoSizeText(
                                          '₹ ${(widget.order.products[index].noOfUnits * widget.order.products[index].rate).toStringAsFixed(1)}')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Divider(),
          InkWell(
            onTap: () {
              basicContentEasyDialog(context,
                  """Hello,
I have issue/query regarding my order placed on  ${DateFormat.yMMMEd().format(DateTime.parse(widget.order.createdAt))} ,
ORDER ID ${widget.order.orderId.toString()}. """);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Need some help?',
                    style: TextStyle(color: blue),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Shipping Details',
                        style: TextStyle(
                          color: grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.order.user.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    widget.order.deliveryAddress,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Email:'),
                      widget.order.user.email != null
                          ? Text(
                              widget.order.user.email,
                            )
                          : Text(''),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Phone no:'),
                      widget.order.user.mobileNo != null
                          ? Text(
                              "+91 " + widget.order.user.mobileNo,
                            )
                          : Text('')
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Price Details',
                        style: TextStyle(
                          color: grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "List Price",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        " ₹" + widget.order.baseAmount.toStringAsFixed(1),
                        style: TextStyle(
                            color: grey,
                            decoration: TextDecoration.lineThrough),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Selling Price',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(" ₹" +
                          (widget.order.amount - widget.order.deliveryCharge)
                              .toStringAsFixed(1))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Discount',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text("- ₹" + (widget.order.discount).toStringAsFixed(1))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total amount'),
                      Text(" ₹" +
                          (widget.order.amount - widget.order.discount)
                              .toStringAsFixed(1)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Payment Mode'),
                      Text(widget.order.paymentMode.toUpperCase()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          
         
         widget.order.orderStatus == 'delivered'
              ?  FlatButton(
              onPressed: () =>downloadFile(),color: red,textColor: white,padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Download Invoice")):Container(),
          widget.order.orderStatus == 'pending'|| widget.order.orderStatus == 'on the way'
              ? RoundedLoadingButton(
                  width: 150,
                  height: 40,
                  controller: _btnController,
                  onPressed: () {
                    updateOrder(widget.order.id);
                  },
                  color: red,
                  child: Text(
                    message,
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
              SizedBox(height: 10,)
        ])));
  }
}
