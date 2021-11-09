import 'package:flutter/material.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';

class AddNewVehical extends StatefulWidget {
  @override
  _AddNewVehicalState createState() => _AddNewVehicalState();
}

class _AddNewVehicalState extends State<AddNewVehical> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).textTheme.headline6!.color,
                ),
              ),
            ),
            Text(
              AppLocalizations.of('Add a new vehicle'),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6!.color,
                  ),
            ),
            SizedBox(),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, top: 14),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('VEHICLE BRAND'),
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Toyota'),
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
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
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('MODEL'),
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Camry'),
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
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
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('YEAR'),
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '2020',
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
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
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('LICENSE PLATE'),
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '43A 36A.82',
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
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
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('COLOR'),
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Black'),
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
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
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('BOOKING TYPE'),
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Taxi 7 Seat'),
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of('COMPLETE'),
                  style: Theme.of(context).textTheme.button!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ConstanceData.secoundryFontColor,
                      ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        ),
      ),
    );
  }
}
