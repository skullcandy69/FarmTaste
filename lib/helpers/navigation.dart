import 'package:flutter/material.dart';

void changeScreen(BuildContext context,Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));

}

void changeScreenRepacement(BuildContext context,Widget widget){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>widget));

}