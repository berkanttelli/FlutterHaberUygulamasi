import 'package:flutter/material.dart';
import 'loginregisterPage.dart';
import 'package:splashscreen/splashscreen.dart';






void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
        home: SplashScreen(
      seconds: 3,
      backgroundColor: Colors.purple[200],
      image: Image.asset('assets/mask.png'),
      loaderColor: Colors.white,
      photoSize: 150.5,
      navigateAfterSeconds: LoginRegisterPage(),
    ));
  }
}
