import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/wallet/paymentMethod.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            SizedBox(
              height: AppBar().preferredSize.height,
              width: AppBar().preferredSize.height + 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Icon(
                      Icons.dehaze,
                      color: ConstanceData.secoundryFontColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of('My Wallet'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ConstanceData.secoundryFontColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: AppBar().preferredSize.height,
              width: AppBar().preferredSize.height + 40,
            ),
          ],
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Wallet',
          ),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Text(
                                        AppLocalizations.of('Cash'),
                                        style: Theme.of(context).textTheme.button!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: ConstanceData.secoundryFontColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  color: ConstanceData.secoundryFontColor,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Text(
                                        AppLocalizations.of('Discount'),
                                        style: Theme.of(context).textTheme.button!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Text(
                          '\$325.00',
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          AppLocalizations.of('TOTAL EARN'),
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14, left: 14, top: 16, bottom: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('PAYMENT HISTORY'),
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 24,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        ConstanceData.user2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Elve Bamett'),
                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.headline6!.color,
                                            ),
                                      ),
                                      Text(
                                        '#6467488',
                                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).disabledColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    '\$25.00',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.headline6!.color,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Theme.of(context).disabledColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 24,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        ConstanceData.user1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Isaiah Francis'),
                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.headline6!.color,
                                            ),
                                      ),
                                      Text(
                                        '#568677',
                                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).disabledColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    '\$12.00',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.headline6!.color,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Theme.of(context).disabledColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 24,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        ConstanceData.user3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Luala Briggs'),
                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.headline6!.color,
                                            ),
                                      ),
                                      Text(
                                        '#464654',
                                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).disabledColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    '\$34.00',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.headline6!.color,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Theme.of(context).disabledColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 24,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        ConstanceData.user4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Ray Young'),
                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.headline6!.color,
                                            ),
                                      ),
                                      Text(
                                        '#8089056',
                                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).disabledColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    '\$50.00',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.headline6!.color,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Theme.of(context).disabledColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 24,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        ConstanceData.user5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Betty Palmer'),
                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.headline6!.color,
                                            ),
                                      ),
                                      Text(
                                        '#89548789',
                                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).disabledColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    '\$40.00',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.headline6!.color,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethod(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 24,
                            child: Icon(
                              FontAwesomeIcons.dollarSign,
                              color: ConstanceData.secoundryFontColor,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppLocalizations.of('Payment method'),
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.headline6!.color,
                                ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).disabledColor,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 6,
              )
            ],
          )
        ],
      ),
    );
  }
}
