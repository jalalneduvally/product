import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product/features/splash_screen.dart';
var h;
var w;
var currentuserid;
var currentusername;
var currentuseremail;
var currentusernumber;
var currentuserimage;

bool loggedin =false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    h=MediaQuery.of(context).size.height;
    w=MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
