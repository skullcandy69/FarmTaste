import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/provider/auth.dart';
import 'package:provider/provider.dart';

class Address extends StatefulWidget {
  final Result res;
  Address(this.res);
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  initState() {
    super.initState();
  }

  bool editaddress = false;
  bool nameedit = false;

  FocusNode address = FocusNode();
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    authprovider.adddress=TextEditingController(text: widget.res.user.address);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pcolor,
        title: Text('Deliver Address'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  height: 220,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text(
                          'Current Address',
                          style: TextStyle(
                            color: grey,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              editaddress = true;
                            });
                            address.requestFocus();
                          },
                        ),
                      ),
                      //  Padding(
                      //    padding: const EdgeInsets.only(left:10.0),
                      //    child: Row(
                      //      children: <Widget>[
                      //        RichText(text: TextSpan(
                      //        text: '${widget.res.user.address} \n',style: TextStyle(color: black,fontSize: 17,fontWeight: FontWeight.w400),
                      //        children: <TextSpan>[
                      //           new TextSpan(text: widget.res.user.pincode.toString(),style: TextStyle(color: black)),
                      //        ]
                      //        ),),
                      //      ],
                      //    ),
                      //  )
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: authprovider.adddress,
                          enabled: editaddress,
                          focusNode: address,
                          // autofocus: true,
                          // onSubmitted: con(),
                          // onEditingComplete:unFocus(),
                          // initialValue: 'ghbnvbnvbn',
                          decoration: InputDecoration(
                              // hintText: '${widget.res.user.address}',
                              // hintText: '${widget.res.user.address}',
                              hintStyle: TextStyle(color: black),
                              border: InputBorder.none),
                            
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: authprovider.pincode,
                          enabled: false,
                          // focusNode: address,
                          // autofocus: true,
                          // onEditingComplete:unFocus(),
                          decoration: InputDecoration(
                              // hintText: '${widget.res.user.address}',
                              hintText: '${widget.res.user.pincode}',
                              hintStyle: TextStyle(color: black),
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () => authprovider.updateUser()),
    );
  }

  // unFocus() {
  //   address.unfocus();
  //   setState(() {
  //     editaddress=false;
  //   });
  // }
}