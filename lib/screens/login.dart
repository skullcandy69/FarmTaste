import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/widgets/city_card.dart';
import 'package:grocery/widgets/existing_customer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool _showexistingcustomer = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/intro.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(
                  //   height: 50,
                  // ),
                  // Center(

                  // child: Image.asset('images/LOGO.png',scale: 10,semanticLabel: 'WELCOME',),
                  // ),
                  AutoSizeText(
                    'Welcome',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    onPressed: () {
                      changeScreen(context, City());
                    },
                    color: Colors.blue,
                    child: Text('              New Customer          '),
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                  RaisedButton(
                    onPressed: () {
                      changeScreenRepacement(
                          context,
                          ExistingCustomer(
                            signup: false,
                            title: 'LOGIN',
                          ));
                    },
                    color: Colors.white,
                    child: Text('          Existing Customer        '),
                    textColor: Colors.blue,
                    elevation: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
