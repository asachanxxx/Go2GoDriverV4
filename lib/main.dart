import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_cab_driver/Services/authService.dart';
import 'package:my_cab_driver/auth/documentInfo.dart';
import 'package:my_cab_driver/auth/legacyLoginScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/auth/loginScreen.dart';
import 'package:my_cab_driver/e2e/UITest.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/setting/settingScreen.dart';
import 'appTheme.dart';
import 'auth/signUpScreen.dart';
import 'history/historyScreen.dart';
import 'home/homeScreen.dart';
import 'introduction/LocationScreen.dart';
import 'introduction/introductionScreen.dart';
import 'inviteFriend/inviteFriendScreen.dart';
import 'notification/notificationScree.dart';
import 'package:my_cab_driver/wallet/myWallet.dart';
import 'constance/constance.dart' as constance;
import 'package:flutter/foundation.dart';



/// Define a top-level named handler which background/terminated messages will
/// call.
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       appId: '1:151650714439:android:d4df71ac0251690d63c262',
  //       apiKey: 'AIzaSyAZENrJd5IZp7sISusn7UTuHiwx14yRtws',
  //       messagingSenderId: '297855924061',
  //       projectId: 'go2go-dev-5534c',
  //       databaseURL: 'https://go2go-dev-5534c-default-rtdb.asia-southeast1.firebasedatabase.app',
  //     ));
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  String  name = 'foo';
  FirebaseOptions  firebaseOptions = const FirebaseOptions(
    appId: '1:151650714439:android:d4df71ac0251690d63c262',
    apiKey: 'AIzaSyAZENrJd5IZp7sISusn7UTuHiwx14yRtws',
    messagingSenderId: '297855924061',
    projectId: 'go2go-dev-5534c',
    databaseURL: 'https://go2go-dev-5534c-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  FirebaseApp app =  await Firebase.initializeApp(name: name, options: firebaseOptions);

  /// Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',// title
    description:  'This channel is used for important notifications.',// description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation< AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(new MyApp()));
}



class MyApp extends StatefulWidget {
  static setCustomeTheme(BuildContext context, int index) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setCustomeTheme(index);
  }

  static setCustomeLanguage(BuildContext context, String languageCode) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
   static String  name = 'go2go';
   static FirebaseOptions  firebaseOptions = const FirebaseOptions(
    appId: '1:151650714439:android:d4df71ac0251690d63c262',
    apiKey: 'AIzaSyAZENrJd5IZp7sISusn7UTuHiwx14yRtws',
    messagingSenderId: '297855924061',
    projectId: 'go2go-dev-5534c',
    databaseURL: 'https://go2go-dev-5534c-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(name: name, options: firebaseOptions);



  ///Set theme values
  setCustomeTheme(int index) {
    if (index == 6) {
      setState(() {
        AppTheme.isLightTheme = true;
      });
    } else if (index == 7) {
      setState(() {
        AppTheme.isLightTheme = false;
      });
    } else {
      setState(() {
        constance.colorsIndex = index;
        constance.primaryColorString = ConstanceData().colors[constance.colorsIndex];
        constance.secondaryColorString = constance.primaryColorString;
      });
    }
  }
  String locale = "en";
  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

   @override
   void initState() {
     super.initState();
     FirebaseMessaging.instance
         .getInitialMessage()
         .then((RemoteMessage? message) {
       if (message != null) {
         print(message);
       }
     });
   }

  @override
  Widget build(BuildContext context) {
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
      statusBarBrightness: AppTheme.isLightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: AppTheme.isLightTheme ? Colors.white : Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
    ));
    return FutureBuilder(
      /// Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        /// Check for errors
        if (snapshot.hasError) {
          return new Directionality(
              textDirection: TextDirection.ltr,
              child: loading(context,'Connection error with the servers.Please contact the GO2Go support team')
          );
        }
        /// Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {

          var currentRouteName = handleInitializeEvents();
          print("currentRouteName $currentRouteName");

          return MaterialApp(
            title: 'Go2Go Driver',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(),
            routes: routes,
            initialRoute: currentRouteName,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return new Directionality(
            textDirection: TextDirection.ltr,
            child: loading(context,'Go2Go Driver')
        );
      },
    );
  }

  handleInitializeEvents() {
    ///we need to check if the current FirebaseAuth.instance.currentUser
    /// is on the drivers node. if node we have to direct to register
    var currentFirebaseUser = FirebaseAuth.instance.currentUser;
    var routeName = Routes.LOGIN2;
    print("currentFirebaseUser $currentFirebaseUser");

    if (currentFirebaseUser == null) {
      return routeName;
    } else {
      CustomParameters.currentFirebaseUser = currentFirebaseUser!;
      var hasAssociateDriverAccount =  AuthService()
          .getCheckUidHasDriverAccount(currentFirebaseUser.uid);
      routeName = Routes.HOME;
    }
    return routeName;
  }


  var routes = <String, WidgetBuilder>{
    Routes.LOGIN2: (BuildContext context) => LegacyLoginScreen(),
    Routes.INTRODUCTION: (BuildContext context) => new IntroductionScreen(),
    Routes.ENABLELOCATION: (BuildContext context) => new EnableLocation(),
    Routes.AUTH: (BuildContext context) => new SignUpScreen(),
    Routes.HOME: (BuildContext context) => new HomeScreen(),
    Routes.HISTORY: (BuildContext context) => new HistoryScreen(),
    Routes.NOTIFICATION: (BuildContext context) => new NotificationScreen(),
    Routes.INVITE: (BuildContext context) => new InviteFriendScreen(),
    Routes.SETTING: (BuildContext context) => new SettingScreen(),
    Routes.WALLET: (BuildContext context) => new MyWallet(),
    Routes.LOGIN: (BuildContext context) => new LoginScreen(),
    Routes.DOCS: (BuildContext context) => new DocumentInfo(),
    Routes.UITEST: (BuildContext context) => new UiTest(),
  };
}

class Routes {
  static const String LOGIN2 = "auth/legacyLoginScreen";
  static const String INTRODUCTION = "/introduction/introductionScreen";
  static const String ENABLELOCATION = "/introduction/LocationScreen";
  static const String AUTH = "/auth/signUpScreen";
  static const String LOGIN = "/auth/loginScreen";
  static const String HOME = "/home/homeScreen";
  static const String HISTORY = "/history/historyScreen";
  static const String NOTIFICATION = "/notification/notificationScree";
  static const String INVITE = "/inviteFriend/inviteFriendScreen";
  static const String SETTING = "/setting/settingScreen";
  static const String WALLET = "/wallet/myWallet";
  static const String DOCS = "/auth/documentInfo";
  static const String UITEST = "/e2e/UITest";
}

loading(context, testToDisplay){
  return new MediaQuery(
    data: new MediaQueryData(),
    child: Scaffold(
      backgroundColor: Color(0xFFFF6767),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 1,
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
            Text(
              testToDisplay,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Color(0xFFFFFFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
          ],
        ),
      ),
    ),
  );
}