import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:route_planning/Providers/getPassengersProvider.dart';
import 'package:route_planning/Providers/getRouteProvider.dart';
import 'package:route_planning/Providers/getStationsProvider.dart';
import 'package:route_planning/Providers/getShuttlesProvider.dart';
import 'package:route_planning/Screens/Splash/splashPage.dart';

import 'Providers/validationLogin.dart';
import 'Providers/validationSignUp.dart';
import 'Service/service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //var email = prefs.getString('email');
  //var studentEmail = prefs.getString("studentEmail");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginValidation()),
      ChangeNotifierProvider(create: (context) => SignupValidation()),
      ChangeNotifierProvider(create: (context) => FirebaseService()),
      ChangeNotifierProvider(create: (context) => GetPassengers()),
      ChangeNotifierProvider(create: (context) => GetShuttles()),
      ChangeNotifierProvider(create: (context) => GetStations()),
      ChangeNotifierProvider(create: (context) => GetRoute()),
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
          ),
          fontFamily: "Muli",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage()),
  ));
}
