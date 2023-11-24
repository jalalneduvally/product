
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


import '../Model_class/category_model.dart';
import '../Model_class/product_model.dart';
import '../core/firebase_constants.dart';
import '../main.dart';

class addProduct extends StatefulWidget {
  const addProduct({super.key});
  @override
  State<addProduct> createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  TextEditingController nameController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  final RegExp priceValidation=RegExp(r'[0-9]$');
  String imgurl ='';

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
  productAdd()async{
    QuerySnapshot snap = await FirebaseFirestore.instance.collection(constants.product)
        .where("prdctName",isEqualTo: nameController.text.trim())
        .get();
    if(snap.docs.isEmpty){
      var uploadFile =await FirebaseStorage.instance.ref().child('userPic/${DateTime.now()}').putFile(file!);
      var geturl = await uploadFile.ref.getDownloadURL();
      imgurl= geturl;
      int id=Timestamp.now().seconds;
      DocumentReference ref =FirebaseFirestore.instance.collection(constants.product).doc("jalal$id");
      final product= ProductList(
        prdctName: nameController.text.trim(),
        price:double.tryParse(priceController.text.trim())??0 ,
        description:descriptionController.text.trim(),
        delete: false,
        image: imgurl??"",
        id: ref.id,
        date: DateTime.now(),
        reference: ref,
        available: toggle,
        category: dropdownvalue,
       );
      ref.set(product.toJson());
      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      showMessage(context, text: "product Added...", color: Colors.green);
    }else{
      showMessage(context, text: "product Existe.....", color: Colors.red);

    }

  }
  List <CategoryModel> category=[];
  var dropdownvalue;
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
  bool toggle = false;
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
        padding: EdgeInsets.all(w*0.03),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: w*0.05,),
              Stack(
                children: [
                  file!=null?
                  CircleAvatar(
                    radius: w*0.25,
                    backgroundImage: FileImage(file),
                  ):
                  CircleAvatar(
                    backgroundColor: Colors.deepOrangeAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("👀",style: TextStyle(fontSize: w*0.2),),
                        SizedBox(width: w*0.03,)
                      ],
                    ),
                    radius: w*0.25,),
                  Positioned(
                    top: w*0.35,
                    left: w*0.35,
                    child: InkWell(
                      onTap: () {
                        pickFile();
                      },
                      child: CircleAvatar(
                        radius: w*0.07,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.camera_alt_outlined,color: Colors.white,),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: w*0.08,),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText:"name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.03)
                    )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
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
              SizedBox(height: w*0.05,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText:"description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.03)
                    )
                ),
              ),
              SizedBox(height: w*0.08,),
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
                      value: dropdownvalue,
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
                          dropdownvalue=newValue!;
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
              SizedBox(height: w*0.05,),
              ElevatedButton(onPressed: () {
                if(file!=null&& nameController.text.isNotEmpty&&
                    priceController.text.isNotEmpty&&
                    descriptionController.text.isNotEmpty&&dropdownvalue!=null){
                  productAdd();
                }else{
                  file==null?showMessage(context,text: "please upload image", color: Colors.red):
                  nameController.text.isEmpty?showMessage(context,text: "please enter name", color: Colors.red):
                  priceController.text.isEmpty?showMessage(context,text: "please enter price ", color: Colors.red):
                  descriptionController.text.isEmpty?showMessage(context,text: "please enter description ", color: Colors.red):
                  showMessage(context,text: "please select value", color: Colors.red);
                }
              }, child: Text("Add"))
            ],
          ),
        ),
      ),
    );
  }
}
