import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../Model_class/category_model.dart';
import '../core/firebase_constants.dart';
import '../main.dart';

class catogaryPage extends StatefulWidget {
  const catogaryPage({super.key});

  @override
  State<catogaryPage> createState() => _catogaryPageState();
}

class _catogaryPageState extends State<catogaryPage> {
  addCategory(){
    int id=Timestamp.now().seconds;
    DocumentReference ref =FirebaseFirestore.instance.collection(constants.category).doc("jalal$id");
    final product= CategoryModel(
        name: categoryController.text,
        delete: false,
        id: ref.id,
        reference: ref);
    ref.set(product.toJson());
    categoryController.clear();
    showMessage(context, text: "product Added...", color: Colors.green);
  }
  TextEditingController categoryController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(
                  hintText: "add category",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            SizedBox(height: w*0.03,),
            InkWell(
              onTap: () {
                if(
                categoryController.text.isNotEmpty){
                  addCategory();

                }else{
                  showMessage(context,text: "please enter category", color: Colors.red);
                }
              },
              child: Container(
                height: w*0.1,
                width: w*0.2,
                child: Center(child: Text("Add")),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(w*0.03)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
