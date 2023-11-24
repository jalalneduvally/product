import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Model_class/category_model.dart';
import '../Model_class/product_model.dart';
import '../core/firebase_constants.dart';
import '../main.dart';

class ProductEdit extends StatefulWidget {
  final ProductList productdetails;
  const ProductEdit({super.key, required this.productdetails});

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  TextEditingController nameController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  final RegExp priceValidation=RegExp(r'[0-9]$');
  var imgurl;
  var file;
  pickFile() async {
    final imagefile=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    file=File(imagefile!.path);
    if(mounted){
      setState(() {
        file=File(imagefile!.path);
      });
    }
    var uploadFile =await FirebaseStorage.instance.ref().child('userPic/${DateTime.now()}').putFile(file!);
    var geturl = await uploadFile.ref.getDownloadURL();
    imgurl= geturl;
    setState(() {

    });
  }
  var drodownvalue;
  List <CategoryModel> category=[];
  getCategory() async {
    QuerySnapshot snapshot =await FirebaseFirestore.instance.collection(constants.category)
        .where("delete",isEqualTo: false).get();
    if(snapshot.docs.isNotEmpty){
      category.clear();
      for(DocumentSnapshot doc in snapshot.docs){
        category.add(CategoryModel.fromjson(doc.data()));
      }
    }
    if(mounted){
      setState(() {

      });
    }
  }
  bool toggle=false;
  @override
  void initState() {
    getCategory();
   imgurl= widget.productdetails.image;
    drodownvalue= widget.productdetails.category;
   nameController.text= widget.productdetails.prdctName;
   priceController.text= widget.productdetails.price.toString();
   descriptionController.text= widget.productdetails.description;
   toggle =widget.productdetails.available;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imgurl),
                  radius: w*0.2,),
                Positioned(
                  top: w*0.25,
                  left: w*0.25,
                  child: InkWell(
                    onTap: () {
                      pickFile();
                    },
                    child: CircleAvatar(
                      radius: w*0.07,
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: w*0.05,),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText:"name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            TextFormField(
              controller: priceController,
              validator: (value) {
                if(!priceValidation.hasMatch(value!)){
                  return "Enter valid price";
                }
              },
              decoration: InputDecoration(
                  labelText:"price",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText:"discount",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: w*0.1,
                  width:w* 0.5,
                  margin: EdgeInsets.only(left:w*0.02),
                  padding: EdgeInsets.only(left:w*0.02,right: w*0.02),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    isExpanded: true,
                    hint: Text("select Category"),
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    value: drodownvalue,
                    items: category.map((e) =>
                        DropdownMenuItem(
                            value: e.name,
                            child: Text(e.name,style: TextStyle(
                                color: Colors.black,
                                fontSize: w*0.04,
                                fontWeight: FontWeight.w500
                            ),))
                    ).toList() ,
                    onChanged: (newValue) {
                      setState(() {
                        drodownvalue=newValue!;
                      });
                    },),
                ),
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        toggle = !toggle;
                        setState(() {});
                      },
                      child: Container(
                        height: w* 0.08,
                        width: w * 0.2,
                        decoration: BoxDecoration(
                            color: toggle ? Colors.green : Colors.grey[300],
                            borderRadius: BorderRadius.circular(w * 0.05)),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeIn,
                      left: toggle ? w * 0.12 : 0,
                      right: toggle ? 0 : w * 0.12,
                      duration: Duration(
                        milliseconds: 200,
                      ),
                      child: InkWell(
                        onTap: () {
                          toggle = !toggle;
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          height: w * 0.08,
                          width: w * 0.08,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(
                        milliseconds: 200,
                      ),
                      // left: toggle? width*0.08:0,
                      top: w * 0.015,
                      left: toggle ? w * 0.015 : w * 0.12,
                      child: Text(
                        toggle ? "ON" : "OFF",
                        style: TextStyle(
                            color: toggle ? Colors.white : Colors.black),
                      ),
                    )
                  ],
                ),
              ],
            ),
            ElevatedButton(onPressed: () {
              if(nameController.text.isNotEmpty&&
                  priceController.text.isNotEmpty&&
                  descriptionController.text.isNotEmpty){
                var a =widget.productdetails.copyWith(prdctName: nameController.text.trim(),
                  image:imgurl ,
                  price: double.tryParse(priceController.text.trim()),
                  description:descriptionController.text.trim(),
                  available: toggle,
                  category: drodownvalue,
                );
                FirebaseFirestore.instance.collection(constants.product).doc(widget.productdetails.id).update(a.toJson());
                Navigator.pop(context);
              }else{
                nameController.text.isEmpty?showMessage(context,text: "please enter name", color: Colors.red):
                priceController.text.isEmpty?showMessage(context,text: "please enter price ", color: Colors.red):
                showMessage(context,text: "please enter description", color: Colors.red);
              }
            }, child: Text("Update"))
          ],
        ),
      ),
    );
  }
}
