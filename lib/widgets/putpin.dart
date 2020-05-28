import 'package:flutter/material.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/home.dart';
import 'package:grocery/screens/login.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class OtpPin extends StatefulWidget {
  final bool signup;
  final int area;
  final int cityId;
  final String otp;
  OtpPin({this.signup, this.cityId, this.area, this.otp});
  @override
  OtpPinState createState() => OtpPinState();
}

class OtpPinState extends State<OtpPin> {
  final FocusNode _pinPutFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
 
  

  Widget onlySelectedBorderPinPut(TextEditingController otp) {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5),
    );

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: PinPut(
        key: _formKey,
        fieldsCount: 5,
        autoValidate: true,
        textStyle: TextStyle(fontSize: 25, color: Colors.black),
        eachFieldWidth: 45,
        eachFieldHeight: 55,
        onSubmit: (String pin) {
          print(pin);
          FocusScope.of(context).unfocus();
        },
        validator: (val) {
          if (val.length < 5) {
            return 'cannot be empty';
          } else if (val != widget.otp) {
            return 'Incorrect OTP';
          }
          return null;
        },
        focusNode: _pinPutFocusNode,
        controller: otp,
        submittedFieldDecoration: pinPutDecoration,
        selectedFieldDecoration: pinPutDecoration.copyWith(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Color.fromRGBO(160, 215, 220, 1),
            )),
        followingFieldDecoration: pinPutDecoration,
        pinAnimationType: PinAnimationType.scale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.otp);
    final authprovider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: pcolor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => changeScreen(context, LoginScreen()))),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
                child: Image.network(
              'https://cdn.dribbble.com/users/2220110/screenshots/8661903/phone-verification-success.gif',
              scale: 2,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            )),
            SizedBox(
              height: 20,
            ),
            Text(
              'Phone Number Verification',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Enter OTP sent to +91 ${authprovider.mobno.text.trim()}',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
            ),
            SizedBox(
              height: 30,
            ),
            onlySelectedBorderPinPut(authprovider.otp),
            RoundedLoadingButton(
              child: Text('Verify OTP!', style: TextStyle(color: Colors.white)),
              controller: _btnController,
              color: green,
              onPressed: () async {
                if (widget.signup == true) {
                  if (await authprovider.signup(
                      widget.cityId.toString(), widget.area.toString())) {
                    _btnController.success();
                    authprovider.clearController();
                    changeScreenRepacement(context, HomePage());
                  } else {
                    _btnController.reset();
                  }
                } else if (widget.signup == false) {
                  if (await authprovider.inputotp()) {
                    _btnController.success();
                    authprovider.clearController();
                    changeScreenRepacement(context, HomePage());
                  } else {
                    _btnController.reset();
                  }
                }
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
