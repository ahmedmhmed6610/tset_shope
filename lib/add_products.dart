

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tset_shope/controllers/product_cntrollers.dart';
import 'package:tset_shope/modells/m_products.dart';
import 'package:tset_shope/services/services.dart';

class Add_products extends StatefulWidget {
  Add_products({Key? key, this.data}) : super(key: key);
  final MProducts?  data;

  @override
  State<Add_products> createState() => _Add_products();
}

class _Add_products extends State<Add_products> {
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();


  ProductsController _productsController = Get.find();

  bool btn = false ;




  @override
  void initState() {
    btn = false;
    _productsController.image_path = null ;

    if(widget.data !=null){
      name.text = widget.data!.name ;
      price.text = widget.data!.price.toString() ;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     extendBodyBehindAppBar: true,
        appBar: AppBar(
     //     backgroundColor: Colors.transparent,
          centerTitle:  true,
          elevation: 0,
          title: Text('اضافة ',style: GoogleFonts.getFont('Cairo',color: Colors.black,)),
        ),
        body:   LayoutBuilder(builder: (context, siz)=>  Container(
            height: siz.maxHeight,
            child:  SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  if(widget.data !=null)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child:  Image.network(url_image+widget.data!.image)),
                  Container(
                    width: 120.w,
                    height: 110.w,
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      //      borderRadius: BorderRadius.circular(75),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        //      color: Colors.cyan[50],
                        child: InkWell(
                          onTap: (){

                            _productsController.get_image();
                            Timer.periodic(Duration(seconds: 3), (Timer t) => setState((){
                            }));

                          },
                          splashColor: Colors.cyanAccent,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor:  Color(0x80d6e1fe),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child:  _productsController.image_path != null ?  Image.file(_productsController.image_path!,height: 200.h,width: 200.w,) :
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      size: siz.maxHeight * 0.045,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: siz.maxHeight * 0.01,
                                ),
                                Text(
                                  'الصورة',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: TextField(
                      autofocus: true,
                      controller: name,
                      style: GoogleFonts.getFont('Cairo',color: Colors.black),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: 'اسم الصنف',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.black
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.blue
                            )
                        ),
                        isDense: true,                      // Added this
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('السعر',style: GoogleFonts.getFont('Cairo',fontWeight: FontWeight.w700),),
                        Container(
                          width: 120.w,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              autofocus: true,
                              controller: price,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.getFont('Cairo',color: Colors.black),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black),
                                hintText: 'السعر',
                                hintMaxLines: 1,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors.black
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.blue
                                    )
                                ),
                                isDense: true,                      // Added this
                                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              ),
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  if(btn == false)
                    Container(
                      width: siz.maxWidth *0.3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            elevation: 5,
                            padding: const EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () async{




                            if(name.text.toString().isEmpty){
                              Get.snackbar('error'.tr, 'errorname'.tr,backgroundColor: Colors.redAccent);
                            }else if(price.text.toString().isEmpty){
                              Get.snackbar('error'.tr, 'السعر',backgroundColor: Colors.redAccent);
                            }else {

                              if(widget.data == null){
                                if(_productsController.image_path ==null){
                                  Get.snackbar('error'.tr, "رجاء تحديد الصور",backgroundColor: Colors.redAccent);
                                }else{
                                  setState((){
                                    btn = true;
                                  });


                                 var image =_productsController.image_path;

                                  _productsController.add_products(name.text.toString().trim(),price.text.trim(),image);
                                  Navigator.pop(context);
                                  name.clear();
                                  price.clear();
                                  _productsController.image_path = null ;
                                }

                              }else{
                                setState((){
                                  btn = true;
                                });
                                var image ;
                                if(_productsController.image_path == null){
                                  _productsController.patch_products( widget.data!.id,name.text.toString().trim(),  price.text.trim(),);
                               Navigator.pop(context);
                               name.clear();
                               price.clear();
                             return  _productsController.image_path = null;
                                }else{
                                 image =  _productsController.image_path;
                                 _productsController.put_products( widget.data!.id,name.text.toString().trim(),price.text.trim(),image);
                                 Navigator.pop(context);
                                 name.clear();
                                 price.clear();
                                 _productsController.image_path = null;
                                }

                              }

                            }

                          }, child: Text('save')),
                    ),
                  if(btn)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Center(
                        child: SizedBox(
                          height: 50.r,
                          width: 50.r,
                          child: const LoadingIndicator(
                            indicatorType: Indicator.ballRotateChase,
                            // colors: AppColors.indicators,
                            strokeWidth: 5,
                            backgroundColor: Colors.transparent,
                            pathBackgroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 40,),
                ],
              ),
            )
        ) )



    );
  }
}
