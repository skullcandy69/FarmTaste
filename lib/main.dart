import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    setupnotification();
    
    Provider.of<ProductModel>(context, listen: false).fetchProducts();

    Timer(Duration(seconds: 3),
        () => changeScreenRepacement(context, SController()));
  }

  Future<void> setupnotification() async {
    await OneSignal.shared.init("f8e1e308-b0d5-4453-9601-ce3ea9da054e",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        });
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
                              child: Image.asset('images/appstore.png'))),
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
