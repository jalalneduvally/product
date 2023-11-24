
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product/core/firebase_constants.dart';

import '../Model_class/category_model.dart';
import '../Model_class/product_model.dart';
import '../main.dart';

class viewCategory extends StatefulWidget {
  const viewCategory({super.key});

  @override
  State<viewCategory> createState() => _viewCategoryState();
}

class _viewCategoryState extends State<viewCategory> {
  TextEditingController categoryController= TextEditingController();
  final RegExp priceValidation=RegExp(r'[0-9]$');
  List <CategoryModel> category=[];
  var drodownvalue;
  getCategory()  {
    return FirebaseFirestore.instance.collection(constants.category)
        .where("delete",isEqualTo: false)
        .snapshots().map((event) => event.docs.map((e) => CategoryModel.fromjson(e.data())).toList());
  }
  @override
  void initState() {
    getCategory();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.05),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<CategoryModel>>(
                  stream: getCategory(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      print(snapshot);
                      return Center(child: CircularProgressIndicator(),);
                    }
                    List<CategoryModel> allCategory =snapshot.data!;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: allCategory.length,
                      itemBuilder: (BuildContext context, int index) {
                        CategoryModel category =allCategory[index];
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("Category name: ${category.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: w*0.06
                                      )),
                                ],
                              ),
                              // InkWell(
                              //     onTap: () {
                              //       categoryController.text=category.name;
                              //       showDialog(context: context, builder: (context) {
                              //         return AlertDialog(
                              //             title: Text("update"),
                              //             content: Container(
                              //               height: w*1.2,
                              //               child: Column(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //                 children: [
                              //                   TextFormField(
                              //                     controller: categoryController,
                              //                     decoration: InputDecoration(
                              //                         labelText:"name",
                              //                         border: OutlineInputBorder(
                              //                             borderRadius: BorderRadius.circular(w*0.03)
                              //                         )
                              //                     ),
                              //                   ),
                              //                   ElevatedButton(onPressed: () {
                              //                     if(categoryController.text.isNotEmpty){
                              //                       var a =category.copyWith(name: categoryController.text.trim(),
                              //
                              //                       );
                              //                       FirebaseFirestore.instance.collection(constants.category).doc(category.id).update(a.toJson());
                              //                       Navigator.pop(context);
                              //                     }else{
                              //                      showMessage(context,text: "please enter category", color: Colors.red);
                              //
                              //                     }
                              //                   }, child: Text("Update"))
                              //                 ],
                              //               ),
                              //             )
                              //         );
                              //       },);
                              //     },
                              //     child: Icon(Icons.edit)),
                              InkWell(
                                  onTap: () {
                                    showDialog(context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Do you want to delete?"),
                                          content: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  var a =category.copyWith(
                                                      delete: true
                                                  );
                                                  category.reference.update(a.toJson());
                                                  // FirebaseFirestore.instance.collection(constants.product).doc(product.id).delete();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: w*0.1,
                                                  width: w*0.15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius: BorderRadius.circular(w*0.03),
                                                  ),
                                                  child: Center(
                                                    child: Text("Yes",style:
                                                    TextStyle(
                                                        color: Colors.white
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: w*0.1,
                                                  width: w*0.15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius: BorderRadius.circular(w*0.03),
                                                  ),
                                                  child: Center(
                                                    child: Text("No",style:
                                                    TextStyle(
                                                        color: Colors.white
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },);
                                  },
                                  child: Icon(Icons.delete,color: Colors.redAccent,size: w*0.1,)),
                            ],
                          ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: w*0.05,);
                    },
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
