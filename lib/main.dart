import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/home.dart';
import 'package:grocery/screens/login.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AuthProvider.initialize()),
    ChangeNotifierProvider.value(value: ProductModel()),
  ], child: MyApp()));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getVersion() async {
    var res = await http.get(Uri.parse(GETVERSION));
    print(res.body);
    return int.parse(res.body);
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () => launch(
                  'https://play.google.com/store/apps/details?id=com.farmtaste.grocery'),
            ),
            TextButton(
              child: Text(btnLabelCancel),
              onPressed: () => SystemNavigator.pop(),
            ),
          ],
        );
      },
    );
  }

  int cversion = 5;
  int gversion;
  @override
  void initState() {
    super.initState();
    setupnotification();
    getVersion().then((v){
       Timer(Duration(seconds: 2), () {
      if (v == cversion) {
        changeScreenRepacement(context, SController());
      } else {
        _showVersionDialog(context);
      }
    });
    });
    Provider.of<ProductModel>(context, listen: false).fetchProducts();

    

    // Smartlook.setupAndStartRecording(
    //     '0f0fe4ac9b7614a8e3480fbcfc7d30e00024b450');
  }

  Future<void> setupnotification() async {
    await OneSignal.shared.setAppId("d7af44a8-42d2-4f40-809c-fe50ada70a7a");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.green[400]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 170,
                          height: 170,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset('images/appstore.jpg'))),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Shimmer.fromColors(
                          child: Text(
                            "Farm Taste",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                          baseColor: white,
                          highlightColor: Colors.green[300])
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'One stop \n for all you need',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // getToken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = pref.getString('token');
  //   });
  // }

  // String token;
  // @override
  // void initState() {
  //   super.initState();
  //   getToken();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}

class SController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    switch (auth.Status) {
      case status.Uninitialized:
        return Center(
          child: CircularProgressIndicator(),
        );
      case status.Unauthenticated:
      case status.Authenticating:
        return LoginScreen();
      case status.Authenticated:
        return HomePage();
      default:
        return LoginScreen();
    }
  }
}
