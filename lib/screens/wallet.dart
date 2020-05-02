import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/widgets/Loader.dart';
import 'package:provider/provider.dart';

class Wallet extends StatefulWidget {


  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Wallet'),
            backgroundColor: pcolor,
          ),
          body: FutureBuilder(
              future: authprovider.getUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(child: Loader()),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.89,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          walletDetails(snapshot.data.user),
                          SizedBox(
                            height: 10,
                          ),
                          transactionList(),
                          SizedBox(
                            height: 10,
                          ),
                          // bottomCarouselBar(),
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }

  // bool shouldRefresh(ScrollNotification notification) {
  //   return !widget.isRefreshing;
  // }

  // Future<Null> _handleRefresh() async {
  //   if (widget.isRefreshing) {
  //     await new Future.delayed(new Duration(seconds: 3));
  //     return null;
  //   } else {
  //     widget.onRefresh();
  //   }
  //   await new Future.delayed(new Duration(seconds: 3));

  //   return null;
  // }

  Widget walletDetails(user) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.account_balance, size: 24, color: Colors.green[300]),
              SizedBox(
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user.name,
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      Text(
                        "Available Balance",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "₹ ${user.wallet}",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        user.mobileNo,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget bottomCarouselBar() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: MediaQuery.of(context).size.height * 0.05,
  //     color: Colors.transparent,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         InkWell(
  //           onTap: () {
  //             // showDialog(
  //             //     context: context,
  //             //     builder: (BuildContext context) {
  //             //       return SendMoneyDialog(widget.onSendMoney, widget.user);
  //             //     });
  //           },
  //           child: Container(
  //             height: 50,
  //             padding: EdgeInsets.all(5),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.all(Radius.circular(20)),
  //             ),
  //             child: Center(
  //                 child: Image.asset(
  //               'assets/send_money.png',
  //               fit: BoxFit.contain,
  //             )),
  //           ),
  //         ),
  //         SizedBox(
  //           width: MediaQuery.of(context).size.width * 0.5,
  //         ),
  //         InkWell(
  //           onTap: () {
  //             // showDialog(
  //             //     context: context,
  //             //     builder: (BuildContext context) {
  //             //       return RequestMoneyDialog(widget.onRequestMoney);
  //             //     });
  //           },
  //           child: Container(
  //             height: 50,
  //             width: 50,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.all(Radius.circular(20)),
  //             ),
  //             child: Center(
  //                 child: Image.asset(
  //               'assets/add_money_passbook.png',
  //               fit: BoxFit.contain,
  //             )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget transactionList() {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TabBar(
                // unselectedLabelColor: white,
                // indicatorColor: green,
                // indicator: BoxDecoration(color: green),

                tabs: [
                  Tab(
                    text: 'RECENT TRANSACTIONS',
                  ),
                  Tab(text: 'ALL TRANSACTIONS')
                ], labelColor: green),
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TabBarView(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.54,
                  // child: ListView.builder(
                  //   itemCount: widget.transactions.length <= 10
                  //       ? widget.transactions.length
                  //       : 10,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return TransactionWidget(
                  //       transaction: widget.transactions[index],
                  //       user: widget.user,
                  //     );
                  //   },
                  // ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.54,
                  // child: ListView.builder(
                  //   itemCount: widget.transactions.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return TransactionWidget(
                  //       transaction: widget.transactions[index],
                  //       user: widget.user,
                  //     );
                  //   },
                  // ),
                ),
              ]),
            )
          ],
        ));
  }
}

// class TransactionWidget extends StatelessWidget {

//   const TransactionWidget({Key key, this.transaction, this.user})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String transactionName;
//     IconData transactionIconData;
//     Color color;
//     switch (transaction.status) {
//       case TransactionStatus.success:
//         if (transaction.senderId == user.id) {
//           transactionName = "Sent";
//           transactionIconData = Icons.arrow_upward;
//           color = Theme.of(context).primaryColor;
//         } else {
//           transactionName = "Received";
//           transactionIconData = Icons.arrow_downward;
//           color = Colors.green;
//         }
//         break;
//       case TransactionStatus.failure:
//         transactionName = "Received";
//         transactionIconData = Icons.arrow_downward;
//         color = Colors.green;
//         break;
//       case TransactionStatus.pending:
//         transactionName = "Pending";
//         transactionIconData = Icons.arrow_downward;
//         color = Colors.orange;
//         break;
//     }
//     return Container(
//       margin: EdgeInsets.all(10.0),
//       padding: EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 5.0,
//             color: Colors.grey[350],
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: <Widget>[
//           Flexible(
//             flex: 1,
//             child: Stack(
//               children: <Widget>[
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(15.0),
//                   child: CachedNetworkImage(
//                     fit: BoxFit.fill,
//                     imageUrl:
//                         "http://www.brooklynartscouncil.org/images_sys/layout/default_profile_image.jpg",
//                     alignment: Alignment.center,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     width: 15.0,
//                     height: 15.0,
//                     decoration: BoxDecoration(
//                       color: color,
//                       shape: BoxShape.circle,
//                     ),
//                     child: FittedBox(
//                       child: Icon(
//                         transactionIconData,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(width: 5.0),
//           Flexible(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         Text(
//                           transaction.name,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       " ₹${transaction.amount}",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "${DateFormat.jms().format(DateTime.parse(transaction.timestamp))}",
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     Text(
//                       "$transactionName",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: color,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   "${DateFormat.yMMMMd().format(DateTime.parse(transaction.timestamp))}",
//                   style: TextStyle(color: Colors.grey[700]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
