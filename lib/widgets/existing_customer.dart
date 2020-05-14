import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/login.dart';
import 'package:grocery/widgets/city_card.dart';
import 'package:grocery/widgets/putpin.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
  login(mobno, context) async {
    var response = await http.post(OTP, body: {"mobile_no": mobno});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    // return response.statusCode.toString();
    if (response.statusCode == 200) {
      changeScreen(context, OtpPin());
    } else {
      print('failed');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return Scaffold(
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
      body: SafeArea(
        child: Form(
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
                    height: 50,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: blue, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      controller: authprovider.mobno,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'cannot be empty';
                        }
                        return '';
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.phone_android,
                              color: blue,
                            ),
                          ),
                          hintText: '10 digit Mobile Number',
                          hintStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    child: ArgonTimerButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.25,
                      onTap: (startTimer, btnState) async {
                        if (btnState == ButtonState.Idle) {
                          startTimer(1);
                        }
                        if (widget.signup == true) {
                          if (await authprovider.genOtpSignup()) {
                            changeScreenRepacement(
                                context,
                                OtpPin(
                                  signup: widget.signup,
                                  cityId: widget.cityId,
                                  area: widget.area,
                                ));
                          } else {
                            EasyDialog(
                                closeButton: true,
                                cornerRadius: 10.0,
                                fogOpacity: 0.1,
                                width: 280,
                                height: 180,
                                title: Text(
                                  "Already Registered",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.2,
                                ),
                                descriptionPadding: EdgeInsets.only(
                                    left: 17.5, right: 17.5, bottom: 15.0),
                                description: Text(
                                  "Please Login",
                                  textScaleFactor: 1.1,
                                  textAlign: TextAlign.center,
                                ),
                                topImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQg3QH1XAL4oXhz3kBG0F1MT_cE4Oe4wj_K5YPUTOflFvP31L19&usqp=CAU",
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 12.0), // Needed for the button design
                                contentList: [
                                  // SizedBox(height: 20,),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: pcolor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight:
                                                Radius.circular(10.0))),
                                    child: FlatButton(
                                      onPressed: () {
                                        changeScreenRepacement(
                                            context,
                                            ExistingCustomer(
                                              signup: false,
                                              title: 'LOGIN',
                                            ));
                                      },
                                      child: Text(
                                        "Take me to Login ",
                                        textScaleFactor: 1.3,
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                  ),
                                ]).show(context);
                          }
                        } else {
                          if (await authprovider.genOtplogin()) {
                            changeScreenRepacement(
                                context, OtpPin(signup: widget.signup));
                          } else {
                            EasyDialog(
                                closeButton: true,
                                cornerRadius: 10.0,
                                fogOpacity: 0.1,
                                width: 280,
                                height: 180,
                                title: Text(
                                  "New User?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.2,
                                ),
                                descriptionPadding: EdgeInsets.only(
                                    left: 17.5, right: 17.5, bottom: 15.0),
                                description: Text(
                                  "Please Register First",
                                  textScaleFactor: 1.1,
                                  textAlign: TextAlign.center,
                                ),
                                topImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQg3QH1XAL4oXhz3kBG0F1MT_cE4Oe4wj_K5YPUTOflFvP31L19&usqp=CAU",
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 12.0), // Needed for the button design
                                contentList: [
                                  // SizedBox(height: 30,),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: pcolor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight:
                                                Radius.circular(10.0))),
                                    child: FlatButton(
                                      onPressed: () {
                                        changeScreenRepacement(context, City());
                                      },
                                      child: Text(
                                        "Register",
                                        textScaleFactor: 1.3,
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                  ),
                                ]).show(context);
                          }
                        }
                      },
                      child: Text(
                        "send OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      loader: (timeLeft) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: Text(
                            "$timeLeft",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        );
                      },
                      borderRadius: 5.0,
                      color: blue,
                    ),
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
