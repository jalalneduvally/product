import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product/core/firebase_constants.dart';
import 'package:product/features/product_edit_page.dart';
import '../Model_class/product_model.dart';
import '../main.dart';

class viewProduct extends StatefulWidget {
  const viewProduct({super.key});

  @override
  State<viewProduct> createState() => _viewProductState();
}

class _viewProductState extends State<viewProduct> {
  getProduct(){
    return FirebaseFirestore.instance.collection(constants.product)
        .where("delete",isEqualTo: false)
        .orderBy("date",descending: true)
        .snapshots().map((event) => event.docs.map((e) => ProductList.fromJson(e.data())).toList());
  }
  @override
  void initState() {
    getProduct();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ProductList>>(
                stream: getProduct(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    print(snapshot);
                    return Center(child: CircularProgressIndicator(),);
                  }
                  List<ProductList> allProduct =snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: allProduct.length,
                    itemBuilder: (BuildContext context, int index) {
                      ProductList product =allProduct[index];
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: w*0.4,
                                  width: w*0.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(w*0.03),
                                      image: DecorationImage(image: NetworkImage(product.image),fit: BoxFit.cover)
                                  ),
                                ),
                                Positioned(
                                  bottom: w*0.025,
                                  child: Container(
                                    height: w*0.07,
                                    width: w*0.3,
                                    color: Colors.white60,
                                    child: Center(child: Text(product.available?"Available":"Not Available",
                                    style: TextStyle(
                                      fontSize: w*0.04,
                                      fontWeight: FontWeight.w600
                                    ),)),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${product.prdctName}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w*0.04
                                    )),
                                SizedBox(height: w*0.03,),
                                Text("price: ${product.price.toString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w*0.04
                                    )),
                                SizedBox(height: w*0.03,),
                                Text("description: ${product.description.toString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w*0.04
                                    )),
                                SizedBox(height: w*0.03,),
                                Text("category: ${product.category.toString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w*0.04
                                    )),
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEdit(productdetails: product),));
                                },
                                child: Icon(Icons.edit,size: w*0.08,color: Colors.blueAccent,)),
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
                                                var a =product.copyWith(
                                                    delete: true
                                                );
                                                product.reference.update(a.toJson());
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
                                child: Icon(Icons.delete,size: w*0.08,color: Colors.redAccent,)),
                          ],
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: w*0.03,);
                  },
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
