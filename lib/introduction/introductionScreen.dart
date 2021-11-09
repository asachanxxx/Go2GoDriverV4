import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../main.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  late PageController pageController;

  var appBarheight = 0.0;

  initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    appBarheight = AppBar().preferredSize.height;
    var children = <Widget>[
      Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: FadeTransition(
              opacity: animation,
              child: Image.asset(
                ConstanceData.acceptjob,
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          Text(
            AppLocalizations.of('Accept a Job'),
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context).textTheme.headline6!.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Text(
              AppLocalizations.of('Lorem ipsum dolor sit amet, consectetur adipisc elit. Nullam ac vestibulum erat.'),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Theme.of(context).textTheme.headline6!.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.ENABLELOCATION);
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Text(
                  AppLocalizations.of('Skip'),
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: appBarheight,
          ),
        ],
      ),
      Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
          FadeTransition(
            opacity: animation,
            child: Image.asset(
              ConstanceData.location,
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
          ),
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          Text(
            AppLocalizations.of('Tracking Realtime'),
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context).textTheme.headline6!.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Text(
              AppLocalizations.of('Lorem ipsum dolor sit amet, consectetur adipisc elit. Nullam ac vestibulum erat.'),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Theme.of(context).textTheme.headline6!.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.ENABLELOCATION);
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Text(
                  AppLocalizations.of('Skip'),
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: appBarheight,
          ),
        ],
      ),
      Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
          FadeTransition(
            opacity: animation,
            child: Image.asset(
              ConstanceData.wallet,
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
          ),
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          Text(
            AppLocalizations.of('Earn Money'),
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context).textTheme.headline6!.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Text(
              AppLocalizations.of('Lorem ipsum dolor sit amet, consectetur adipisc elit. Nullam ac vestibulum erat.'),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Theme.of(context).textTheme.headline6!.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 50, left: 50),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.ENABLELOCATION);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of('GET STARTED'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ConstanceData.secoundryFontColor,
                        ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: appBarheight,
          ),
        ],
      ),
    ];
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      PageView(
                        controller: pageController,
                        children: children,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: 3,
                            effect: SlideEffect(
                              strokeWidth: 1.5,
                              dotColor: (Colors.grey[350]!),
                              activeDotColor: Theme.of(context).primaryColor,
                            ),
                          ),

                          //  PageIndicator(
                          //   layout: layout,
                          //   size: 12,
                          //   activeSize: 12,
                          //   controller: pageController,
                          //   space: 8,
                          //   count: 3,
                          //   color: Theme.of(context).dividerColor,
                          //   activeColor: Theme.of(context).primaryColor,
                          // ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
