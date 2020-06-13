import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

basicContentEasyDialog(BuildContext context , String message) {
  EasyDialog(
      title: Text(
        "REACH US THROUGH",
        style: TextStyle(fontWeight: FontWeight.bold),
        textScaleFactor: 1.2,
      ),
      topImage: AssetImage(
          'images/Artboard.png'),
      height: 350,
      closeButton: true,
      contentList: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListTile(
                leading: Container(
                    height: 45, child: Image.asset('images/call.png')),
                title: Text('Call Us'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => launch("tel://8750185501")),
            ListTile(
              onTap: () => launch("mailto: support@farmtaste.co.in"),
              leading:
                  Container(height: 45, child: Image.asset('images/email.png')),
              title: Text('Mail Us'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Container(
                width: 45,
                child: Image.asset('images/whatsapp.png'),
              ),
              title: Text('WhatsApp'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                launch('https://wa.me/918750185501?text=$message');
              },
            ),
          ],
        )
      ]).show(context);
}
