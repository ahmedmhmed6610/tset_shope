
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tset_shope/modells/m_products.dart';
import 'package:tset_shope/services/services.dart';




class ProductsController extends GetxController {

  File? image_path ;
   //// products
   var products =<MProducts>[].obs;

  var  date_Time =   ''.obs;


  @override
  void onInit() async {
    start_app();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.onInit();
  }

  start_app() {
    fetch_get_Allproducts();
  }

  app_update(){

  }

  @override
  void onReady() {

    super.onReady();
  }

  void _getTime() {
    date_Time(DateFormat.yMd().add_jm().format(DateTime.now()).toString());
  }


  @override
  void dispose() {
    super.dispose();
  }


  user_Active() async{


  }


  Future fetch_get_Allproducts() async {
    try {
      var _data = await Services.get_Allproducts();
      if (_data != null) {
        products.value = _data;
      }
    } finally{}
  }
  Future<void> add_products(name,price,path) async {
    if(await Services.post_Addproducts(name,price,path)){
      fetch_get_Allproducts();
      products.refresh();
    }
  }

  put_products(id,name,price,path) async {
    if(await Services.put_Addproducts(id,name,price,path)){
      fetch_get_Allproducts();
    products.refresh();
    }
  }
  patch_products(id,name,price) async {
    if(await Services.patch_products(id,name,price)){
      fetch_get_Allproducts();
    products.refresh();
    }
  }

  get_image()async{
    final ImagePicker imagePicker = ImagePicker();
    final  image = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    if(image !=null){
      image_path = File(image.path);
      update();
    }


  }

}


