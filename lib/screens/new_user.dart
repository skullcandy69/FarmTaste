import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';


class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://image.freepik.com/free-vector/natural-landscape-cartoon_23-2147499451.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context))
              ],
            ),
            Image.network(
              'https://lh3.googleusercontent.com/proxy/-8M0DpY2UxdOHLw7q3wOu4coS7YntVF6TIr6YfEu7vNke3cwpK4VcIjA56t_pe_1k_8JTo6pDcePps3FNDB-QG0TicJg77w',
              scale: 2,loadingBuilder: (BuildContext context, Widget child,
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
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .65,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: 'Enter name'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                InputDecoration(hintText: 'Enter Email'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: 'Enter Mobile Number'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: 'Enter Alternate Mobile Number'),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 25, right: 25, top: 5),
                        //   child: TextFormField(
                        //     decoration: InputDecoration(hintText: 'Enter Area'),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 25, right: 25, top: 5),
                        //   child: TextFormField(
                        //     decoration:
                        //         InputDecoration(hintText: 'Enter Location'),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: TextFormField(
                            decoration:
                                InputDecoration(hintText: 'Enter PinCode'),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(color: white),
                            ),
                            color: blue,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
