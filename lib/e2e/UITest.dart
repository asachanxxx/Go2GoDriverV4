import 'package:flutter/material.dart';
import 'package:my_cab_driver/auth/documentInfo.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/documentManagement/docManagementScreen.dart';
import 'package:my_cab_driver/documentManagement/drivingLicenseScreen.dart';
import 'package:my_cab_driver/history/historyScreen.dart';
import 'package:my_cab_driver/home/chatScreen.dart';
import 'package:my_cab_driver/home/homeScreen.dart';
import 'package:my_cab_driver/home/riderList.dart';
import 'package:my_cab_driver/home/userDetail.dart';
import 'package:my_cab_driver/introduction/LocationScreen.dart';
import 'package:my_cab_driver/introduction/introductionScreen.dart';
import 'package:my_cab_driver/notification/notificationScree.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';
import 'package:my_cab_driver/pickup/ticketScreen.dart';
import 'package:my_cab_driver/setting/myProfile.dart';
import 'package:my_cab_driver/setting/settingScreen.dart';
import 'package:my_cab_driver/vehicalManagement/addVehicalScreen.dart';
import 'package:my_cab_driver/vehicalManagement/vehicalmanagementScreen.dart';
import 'package:my_cab_driver/wallet/myWallet.dart';
import 'package:my_cab_driver/wallet/paymentMethod.dart';

import '../main.dart';

class UiTest extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<UiTest> {
  var appBarheight = 20.0;
  @override
  Widget build(BuildContext context) {
    appBarheight = AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40,),







                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('ChatScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RiderList(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('RiderList'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),

                      /// ********************************** ********************************** ********************************** ********************************** **********************************

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(userId: 1),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('UserDetailScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('HistoryScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IntroductionScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('IntroductionScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EnableLocation(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('EnableLocation'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('NotificationScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PickupScreen(),
                              //   ),
                              // );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('PickupScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TicketScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('TicketScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyProfile(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('MyProfile'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('SettingScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewVehical(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('AddNewVehical'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VehicalManagement(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('VehicalManagement'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyWallet(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('MyWallet'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentMethod(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('PaymentMethod'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocmanagementScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('Docmanagement'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),

                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DrivingLicenseScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('DrivingLicense'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocumentInfo(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('DocumentInfo'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      /// ********************************** ********************************** ********************************** ********************************** **********************************
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('HomeScreen'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocumentInfo(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('DocumentInfo'),
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
