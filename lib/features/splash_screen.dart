import 'package:flutter/material.dart';
import 'package:product/features/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_page.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  loggedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedin =prefs.getBool('login')??false;
    currentusername = prefs.getString("name");
    currentuseremail = prefs.getString("email");
    currentusernumber = prefs.getString("number");
    currentuserimage = prefs.getString("image");
    Future.delayed(Duration(seconds: 2))
        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => loggedin ==false?LoginPage():HomePage(),)));
  }
  void initState() {
    // TODO: implement initState
    loggedpref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("💣",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: w*0.25,
            ),),
          SizedBox(height: w*0.05,),
          Text("Pedikanda  ith pottilla",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: w*0.1,
                color:Colors.redAccent
            ),),
                  ],
      ),
    );
  }
}
