import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/login.dart';
import 'package:grocery/widgets/putpin.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ExistingCustomer extends StatefulWidget {
  final int area;
  final int cityId;
  final bool signup;
  final String title;
  ExistingCustomer({this.area, this.cityId, this.signup, this.title});

  @override
  _ExistingCustomerState createState() => _ExistingCustomerState();
}

class _ExistingCustomerState extends State<ExistingCustomer> {
  bool hasError = false;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  bool referal = false;

  String code='';

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => changeScreen(context, LoginScreen()),
          ),
          title: Text(
            widget.title,
            style: TextStyle(color: white),
          ),
          backgroundColor: pcolor,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 250,
                    child: Image.asset(
                      'images/login.gif',

                      // ,scale: 2,
                    ),
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 350,
                    child: TextFormField(
                      maxLength: 10,
                      controller: authprovider.mobno,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.length == 0) {
                          _btnController.stop();
                          return 'cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10)),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.phone_android,
                            ),
                          ),
                          hintText: '10 digit Mobile Number',
                          hintStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                  hasError
                      ? Text(
                          errorMessage + "!!",
                          style: TextStyle(color: red),
                        )
                      : Text(''),
                  SizedBox(
                    height: 10,
                  ),
                  referal == true
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter code' 
                            ),
                            onChanged: (val){
                              setState(() {
                                code=val;
                              });
                            },
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              referal = true;
                            });
                          },
                          child: Text(
                            widget.signup == true ? 'Enter referral code?' : '',
                            style: TextStyle(color: blue),
                          )),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedLoadingButton(
                    child: Text('Send OTP!',
                        style: TextStyle(color: Colors.white)),
                    controller: _btnController,
                    color: green,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (widget.signup == false) {
                          String message = await authprovider.genOtplogin();
                          if (message == 'Kindly Register First') {
                            _btnController.reset();
                            setState(() {
                              hasError = true;
                              errorMessage = message;
                            });
                          } else {
                            _btnController.success();
                            changeScreenRepacement(context,
                                OtpPin(signup: widget.signup, otp: message));
                          }
                        } else {
                          String message = await authprovider.genOtpSignup();
                          if (message == 'Already Registered, Please Login') {
                            _btnController.reset();
                            setState(() {
                              hasError = true;
                              errorMessage = message;
                            });
                          } else {
                            _btnController.success();
                            changeScreenRepacement(
                                context,
                                OtpPin(
                                  otp: message,
                                  signup: widget.signup,
                                  cityId: widget.cityId,
                                  area: widget.area,
                                  code:code
                                ));
                          }
                        }
                      }
                    },
                    width: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
