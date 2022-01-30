import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery/provider/auth.dart';
import 'package:provider/provider.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/widgets/address.dart';
import 'package:grocery/widgets/Policy.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Result user;
  fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Result u = Result.fromJson(json.decode(prefs.getString('response')));
    setState(() {
      user = u;
    });
  }

  Future<dynamic> _refreshLocalGallery(BuildContext context) async {
    await new Future.delayed(new Duration(seconds: 2));
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    Result u = await authprovider.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('response');
    prefs.setString('response', json.encode(u));
    setState(() {
      user = u;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    _refreshLocalGallery(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: pcolor,
          title: Text('PROFILE'),
        ),
        body: RefreshIndicator(
          onRefresh:()=> _refreshLocalGallery(context),
          child: SingleChildScrollView(
            child: user == null
                ? Container(
                  height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    user.user.name == null
                                        ? ''
                                        : user.user.name,
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  Text(
                                    user.user.email == null
                                        ? ""
                                        : user.user.email,
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(
                                width: 100,
                                height: 100,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(300),
                                  onTap: () {},
                                  child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Hero(
                                        tag: 'user',
                                        child: Container(
                                            height: 100,
                                            width: 200,
                                            child:
                                                Image.asset('images/user.png')),
                                      )),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text(
                                "Profile Settings",
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                "Full Name",
                              ),
                              trailing: Text(
                                user.user.name == null ? '' : user.user.name,
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                "EMAIL",
                              ),
                              trailing: Text(
                                user.user.email == null ? "" : user.user.email,
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                "Phone",
                              ),
                              trailing: Text(
                                user.user.mobileNo,
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                "Address",
                              ),
                              trailing: Container(
                                width: MediaQuery.of(context).size.width * .6,
                                height: 50,
                                alignment: Alignment.centerRight,
                                child: AutoSizeText(
                                  user.user.address == null
                                      ? ''
                                      : user.user.address,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                     
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.settings),
                              title: Text(
                                "App Settings",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            ListTile(
                              onTap: ()=>changeScreen(context,Policy()),
                              dense: true,
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.perm_device_information,
                                    size: 22,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Privacy Policy',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              trailing: Text(
                                'English',
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                            ListTile(
                              onTap: ()=>changeScreen(context,Address()),
                              dense: true,
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.place,
                                    size: 22,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Delivery Address",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.help,
                                    size: 22,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Help Support",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          
                            ListTile(
                              dense: true,
                              title: Text(
                                "Version 1.0.1",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              trailing: Icon(
                                Icons.remove,
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.3),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
