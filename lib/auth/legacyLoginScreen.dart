import 'package:animator/animator.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/auth/phoneAuthScreen.dart';
import 'package:my_cab_driver/auth/signUpScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';


class LegacyLoginScreen extends StatefulWidget {
  const LegacyLoginScreen({Key? key}) : super(key: key);

  @override
  _LegacyLoginScreenState createState() => _LegacyLoginScreenState();
}

class _LegacyLoginScreenState extends State<LegacyLoginScreen> {
  String countryCode = "+91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: 300,
              color: Theme.of(context).primaryColor,
              child: Animator<Offset>(
                tween: Tween<Offset>(
                  begin: Offset(0, 0.4),
                  end: Offset(0, 0),
                ),
                duration: Duration(seconds: 1),
                cycles: 1,
                builder: (context, animate, _) => SlideTransition(
                  position: animate.animation,
                  child: Image.asset(
                    ConstanceData.splashBackground,
                    fit: BoxFit.fill,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14, left: 14 , top: 80),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Go2Go'),
                                    style: Theme.of(context).textTheme.headline4!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppLocalizations.of(' Driver'),
                                      style: Theme.of(context).textTheme.headline5!.copyWith(
                                        color: Theme.of(context).textTheme.headline6!.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('log in with e-mail'),
                                    style: Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: TextFormField(
                                  autofocus: true,
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'email/Password',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      size: 20,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context).textTheme.headline1!.color
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: TextFormField(
                                  autofocus: false,
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'password',
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      size: 20,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context).textTheme.headline1!.color,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PhoneVerification(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('LOGIN'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('SIGNUP'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getCountryString(String str) {
    var newString = '';
    var isFirstdot = false;
    for (var i = 0; i < str.length; i++) {
      if (isFirstdot == false) {
        if (str[i] != ',') {
          newString = newString + str[i];
        } else {
          isFirstdot = true;
        }
      }
    }
    return newString;
  }
}



