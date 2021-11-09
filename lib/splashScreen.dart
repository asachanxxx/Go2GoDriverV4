import 'dart:convert';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'Language/LanguageData.dart';
import 'constance/constance.dart' as constance;
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  initState() {
    super.initState();
    myContext = context;
    controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loadNextScreen();
      }
    });
    controller.forward();
  }

  late BuildContext myContext;

  _loadNextScreen() async {
    if (!mounted) return;
    // ignore: unnecessary_null_comparison
    constance.allTextData = AllTextData.fromJson(json.decode(await DefaultAssetBundle.of(myContext).loadString("jsonFile/languagetext.json")));

    await Future.delayed(const Duration(milliseconds: 1000));
    Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            FadeTransition(
              opacity: animation,
              child: Container(
                height: 100,
                width: 100,
                child: Image.asset(
                  ConstanceData.appicon,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                  color: Theme.of(context).primaryColor,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            SizedBox(
              height: 2.1,
            ),
            Container(
              height: 1,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FadeTransition(
              opacity: animation,
              child: Text(
                'MyCab Driver',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).backgroundColor),
              strokeWidth: 2,
            ),
            Animator<Offset>(
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
                  fit: BoxFit.cover,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
