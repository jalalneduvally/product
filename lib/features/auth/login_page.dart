import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:product/Model_class/user_model.dart';
import 'package:product/core/firebase_constants.dart';
import 'package:product/features/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> signInWithGoogle()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true);
    FirebaseAuth auth=FirebaseAuth.instance;
    final GoogleSignIn googleSignIn= GoogleSignIn();
    final GoogleSignInAccount? googleUser= await googleSignIn.signIn();
    final GoogleSignInAuthentication googleauth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken
    );

    final UserCredential userCredential= await auth.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    currentusername=userCredential.user?.displayName;
    currentuseremail=userCredential.user?.email;
    currentusernumber=userCredential.user?.phoneNumber;
    currentuserimage=userCredential.user?.photoURL;
    currentuserid=userCredential.user?.uid;
    print(currentuserimage);
    print(currentusernumber);
    prefs.setString("name", currentusername);
    prefs.setString("email", currentuseremail);
    prefs.setString("image", currentuserimage);
    DocumentSnapshot user= await FirebaseFirestore.instance.collection(constants.user).doc(currentuserid).get();
    if(!user.exists){
      final userModel =UserModel(
          name: currentusername,
          id: currentuserid,
          delete: false,
          reference: user.reference,
          email: currentuseremail,
          date: DateTime.now());
      FirebaseFirestore.instance.collection(constants.user).add(userModel.toJson());
    }

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),), (route) => false);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Container(
                      height: w * 0.15,
                      width: w * 0.2,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(w * 0.03)),
                      child: Center(
                          child: Text(
                        "Google",
                        style:
                            TextStyle(color: Colors.white, fontSize: w * 0.05),
                      ))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
