import 'package:flutter/material.dart';
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://thumbs.dreamstime.com/b/simple-cartoon-meadow-sky-background-beautiful-can-be-used-as-backdrop-print-54367032.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Center(
            
            child: Image.asset('images/LOGO.png',scale: 10,semanticLabel: 'WELCOME',),
            ),
            Text(
              'Welcome',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
                changeScreenRepacement(context, ExistingCustomer(signup: false,title: 'LOGIN',));
              },
              color: Colors.white,
              child: Text('          Existing Customer        '),
              textColor: Colors.blue,
              elevation: 5,
            ),
          ],
        ),
      )),
    );
  }
}
