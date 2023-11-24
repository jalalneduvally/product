import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:product/features/category_tabbar.dart';
import 'package:product/features/tab_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'auth/login_page.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => tabBar(),));
              },
              child: Container(
                  height: w*0.15,
                  width: w*1,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child: Center(child: Text("Add Product",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w*0.06,
                      fontWeight: FontWeight.w800
                    ),))
              ),
            ),
            SizedBox(height: w*0.07,),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryTabbar(),));
              },
              child: Container(
                  height: w*0.15,
                  width: w*1,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child: Center(child: Text("Add Category",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w*0.06,
                      fontWeight: FontWeight.w800
                    ),))
              ),
            ),
            SizedBox(height: w*0.2,),
            Row(
              children: [
                SizedBox(width: w*0.05,),
                Icon(Icons.logout_rounded,color: Colors.redAccent,size: w*0.075,),
                SizedBox(width: w*0.03,),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove("login");
                    GoogleSignIn().signOut();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);

                  },
                  child: Text("Log out",
                    style: TextStyle(
                        fontSize:w*0.06 ,
                        fontWeight: FontWeight.w800,
                        color: Colors.redAccent
                    ),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
