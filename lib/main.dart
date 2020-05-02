import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/home.dart';
import 'package:grocery/screens/login.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AuthProvider.initialize()),
    ChangeNotifierProvider.value(value: ProductModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.solwayTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.green,
      ),
      home: SController(),
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
