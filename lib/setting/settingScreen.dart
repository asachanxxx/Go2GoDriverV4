import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/main.dart';
import 'package:my_cab_driver/vehicalManagement/vehicalmanagementScreen.dart';
import 'package:my_cab_driver/documentManagement/docManagementScreen.dart';
import '../appTheme.dart';
import 'myProfile.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      color: Theme.of(context).textTheme.headline6!.color,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of('Settings'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6!.color,
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
            selectItemName: 'Setting',
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                myProfileDetail(),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                userSettings(),
                SizedBox(
                  height: 16,
                ),
                userDocs(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userDocs() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.NOTIFICATION);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#5AC8FB"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.solidBell,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of('Notification'),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor("#8F8E93"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      FontAwesomeIcons.crown,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  AppLocalizations.of('Terms & Privacy Policy'),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor("#FF2C56"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.help,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  AppLocalizations.of('Contact Us'),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userSettings() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicalManagement(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#FF9503"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.car,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of('vehicle Management'),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocmanagementScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#4BDA65"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.idCard,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of('Document Management'),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor("#FFCC01"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  AppLocalizations.of('Reviews'),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyProfile(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#0078FF"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.globeAsia,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of('Language'),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  Widget myProfileDetail() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 14, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
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
                    AppLocalizations.of('Esther Berry'),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                  ),
                  Text(
                    AppLocalizations.of('5 mutual friends'),
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
