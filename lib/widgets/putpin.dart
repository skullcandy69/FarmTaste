import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/home.dart';
import 'package:grocery/screens/login.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:grocery/helpers/commons.dart';

class OtpPin extends StatefulWidget {
  final bool signup;
  final int area;
  final int cityId;
  OtpPin({this.signup, this.cityId, this.area});
  @override
  OtpPinState createState() => OtpPinState();
}

class OtpPinState extends State<OtpPin> {
  final FocusNode _pinPutFocusNode = FocusNode();

  error() {
    return EasyDialog(
        topImage: NetworkImage(
            'https://previews.123rf.com/images/imagecatalogue/imagecatalogue1610/imagecatalogue161016122/64582913-access-denied-text-rubber-seal-stamp-watermark-tag-inside-rectangular-banner-with-grunge-design-and-.jpg'),
        height: 260,
        closeButton: true,
        title: Text('Wrong Otp',style: TextStyle(fontWeight: FontWeight.bold,fontSize:25 )),
        contentList: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: green,
            height: 50,
            child: FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('Retry')),
          )
        ]).show(context);
  }

  Widget onlySelectedBorderPinPut(TextEditingController otp) {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5),
    );

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: PinPut(
        fieldsCount: 5,
        textStyle: TextStyle(fontSize: 25, color: Colors.black),
        eachFieldWidth: 45,
        eachFieldHeight: 55,
        onSubmit: (String pin) {
          print(pin);
          FocusScope.of(context).unfocus();
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
            ArgonButton(
              height: 50,
              roundLoadingShape: true,
              width: MediaQuery.of(context).size.width * 0.45,
              onTap: (startLoading, stopLoading, btnState) async {
                if (btnState == ButtonState.Idle) {
                  startLoading();
                }
                if (widget.signup == true) {
                  if (await authprovider.signup(
                      widget.cityId.toString(), widget.area.toString())) {
                    stopLoading();
                    authprovider.clearController();
                    changeScreenRepacement(context, HomePage());
                  } else {
                    stopLoading();
                    error();
                  }
                } else if (widget.signup == false) {
                  if (await authprovider.inputotp()) {
                    stopLoading();
                    authprovider.clearController();
                    changeScreenRepacement(context, HomePage());
                  } else {
                    stopLoading();
                    error();
                  }
                } else {
                  // final snackBar = new SnackBar(
                  //     content: new Text("Error: Wrong OTP, login failed!!"),
                  //     backgroundColor: Colors.red);
                  // Scaffold.of(context).showSnackBar(snackBar);
                  stopLoading();
                  print('error');
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              loader: Container(
                padding: EdgeInsets.all(10),
                child: SpinKitRotatingCircle(
                  color: Colors.white,
                  // size: loaderWidth ,
                ),
              ),
              borderRadius: 5.0,
              color: Color(0xFFfb4747),
            ),
          ],
        ),
      ),
    );
  }
}
