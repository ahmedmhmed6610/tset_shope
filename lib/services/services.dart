
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tset_shope/modells/m_products.dart';
var client = http.Client();
String url = 'http://192.168.1.2:3000/api/';
String url_image = 'http://192.168.1.2:3000/';
const headers = {
  "Accept": "application/json",
  "Content-Type": "application/json",
};
class Services{
  //// user



  //// products
  static Future get_Allproducts() async {
    var response = await client.get(Uri.parse(url+'products'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
          print(jsonString);
      return mProductsFromJson(jsonString);
    }else{
      print('object');
    }
  }
  static Future post_Addproducts(name,price,path) async {
    try {
      http.MultipartRequest request = new http.MultipartRequest("POST", Uri.parse(url+'products'));
      request.fields['name'] = name;
      request.fields['price'] = price;
      if (GetPlatform.isMobile && path != null) {
        http.MultipartFile multipartFile = await http.MultipartFile('image', path.readAsBytes().asStream(), path.lengthSync(),filename: path.path.split('/').last);
        request.files.add(multipartFile);
      }
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('save', 'welcome Industrial', backgroundColor: Colors.greenAccent);
        var json = jsonEncode(await response.stream.bytesToString());
        final result = jsonDecode(json);
        return true;
      } else {
        Get.snackbar('error'.tr, 'error internet'.tr, backgroundColor: Colors.deepOrange);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  static Future put_Addproducts(id,name,price,path) async {
    try {
      http.MultipartRequest request = new http.MultipartRequest("PUT", Uri.parse(url+'products/$id'));
      request.fields['name'] = name;
      request.fields['price'] = price;
      if (GetPlatform.isMobile && path != null) {
        http.MultipartFile multipartFile = await http.MultipartFile('image', path.readAsBytes().asStream(), path.lengthSync(),filename: path.path.split('/').last);
        request.files.add(multipartFile);
      }
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('save', 'welcome Industrial', backgroundColor: Colors.greenAccent);
      var json = jsonEncode(await response.stream.bytesToString());
        final result = jsonDecode(json);
        print(result);
        return true;
      } else {
        Get.snackbar('error'.tr, 'error internet'.tr, backgroundColor: Colors.deepOrange);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  static Future patch_products(id,name,price) async {
    try {
      http.MultipartRequest request = new http.MultipartRequest("PATCH", Uri.parse(url+'products/$id'));
      request.fields['name'] = name;
      request.fields['price'] = price;
      // if (GetPlatform.isMobile && path != null) {
      //   http.MultipartFile multipartFile = await http.MultipartFile('image', path.readAsBytes().asStream(), path.lengthSync(),filename: path.path.split('/').last);
      //   request.files.add(multipartFile);
      // }
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('save', 'welcome Industrial', backgroundColor: Colors.greenAccent);
        var json = jsonEncode(await response.stream.bytesToString());
        //      var json = jsonEncode(await response);
        final result = jsonDecode(json);
        print(result);
        return true;
      } else {
        Get.snackbar('error'.tr, 'error internet'.tr, backgroundColor: Colors.deepOrange);
      }
    } catch (e) {
      print(e.toString());
    }
  }

}