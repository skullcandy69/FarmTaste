import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/user_model.dart';

class ReferAndEarn extends StatefulWidget {
  final Result res;
  ReferAndEarn({this.res});
  @override
  _ReferAndEarnState createState() => _ReferAndEarnState();
}

Future<void> share(code) async {
  await FlutterShare.share(
    title: 'Refer and Earn',
    text:
        'Join me on FarmTaste, a secure app for buying daily needs . Enter my code $code to earn ₹51 in your FarmTaste wallet back on your first payment!',
    linkUrl: 'http://farmtaste.in/',
  );
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text('Refer & Earn'),
          backgroundColor: pcolor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .45,
                child: Stack(children: <Widget>[
                  Hero(tag: 'refer',
                                      child: Container(
                      child: Image.asset('images/refer.jpg'),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      // top: 280,
                      right: 5,
                      left: 5,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // Icon(Icons.account_balance_wallet),
                            Container(
                              height: 45,
                              width: 40,
                              child: Image.asset(
                                'images/wallet.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            AutoSizeText(
                              "Share your referral link and invite \nyour friends to earn upto 1000 points",
                              maxLines: 3,stepGranularity: 2,
                            )
                          ],
                        ),
                      )),
                ]
                    // child:
                    ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 120,
                width: 350,
                child: Image.asset(
                  'images/share.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Center(
                child: Text(
                  'YOUR REFERAL CODE',
                  style: TextStyle(color: grey),
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: widget.res.user.referralCode == null
                          ? ''
                          : widget.res.user.referralCode));
                  key.currentState.showSnackBar(SnackBar(
                    content: Text(
                      "Copied to Clipboard!!",
                      style: TextStyle(color: blue),
                    ),
                    backgroundColor: white,
                  ));
                },
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue[50], border: Border.all(color: blue)),
                  child: Center(
                    child: Text(
                        widget.res.user.referralCode == null
                            ? ''
                            : widget.res.user.referralCode,
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/whatsapp.png',
                    scale: 15,
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () => share(widget.res.user.referralCode),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
