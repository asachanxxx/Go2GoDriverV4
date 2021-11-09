import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import '../main.dart';

class AppDrawer extends StatefulWidget {
  final String selectItemName;

  const AppDrawer({ key, required this.selectItemName}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: new ClipRRect(
                            borderRadius: new BorderRadius.circular(50),
                            child: Image.asset(
                              ConstanceData.userImage,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Martha Banks'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                  ),
                                  Text(
                                    'Gold Member',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .color,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.clock,
                            color: ConstanceData.secoundryFontColor,
                            size: 18,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '10.2',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Hourse online'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.tachometerAlt,
                            color: ConstanceData.secoundryFontColor,
                            size: 18,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '30 KM',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Total Distance'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.rocket,
                            color: ConstanceData.secoundryFontColor,
                            size: 20,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '20',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Total Job'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: columDetail(),
          )
        ],
      ),
    );
  }

  Widget columDetail() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 26,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Home') {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.HOME, (Route<dynamic> route) => false);
                  }
                },
                child: Row(
                  children: <Widget>[
                    widget.selectItemName == 'Home'
                        ? selectedData()
                        : SizedBox(),
                    Icon(
                      Icons.home,
                      size: 28,
                      color: widget.selectItemName == 'Home'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      AppLocalizations.of('Home'),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Wallet') {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.WALLET,
                        (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Wallet'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.wallet,
                        size: 20,
                        color: widget.selectItemName == 'Wallet'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Wallet'),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'History') {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.HISTORY,
                        (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'History'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.history,
                        size: 20,
                        color: widget.selectItemName == 'History'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('History'),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Notification') {
                    Navigator.pushNamedAndRemoveUntil(context,
                        Routes.NOTIFICATION, (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Notification'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.solidBell,
                        size: 20,
                        color: widget.selectItemName == 'Notification'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Notifications'),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Invite') {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.INVITE,
                        (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Invite'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.gifts,
                        size: 20,
                        color: widget.selectItemName == 'Invite'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Invite Friends'),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Setting') {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.SETTING,
                        (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Setting'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.cog,
                        size: 20,
                        color: widget.selectItemName == 'Setting'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Settings'),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      Routes.INTRODUCTION, (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.signOutAlt,
                        size: 20,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Logout'),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 28,
          width: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
