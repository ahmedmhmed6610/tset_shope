

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tset_shope/add_products.dart';
import 'package:tset_shope/controllers/product_cntrollers.dart';
import 'package:tset_shope/services/services.dart';

class Home_page extends StatefulWidget {
  Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  double topContainer = 0;
  bool closeTopContainer = false;


  ScrollController controller = ScrollController();

  ProductsController _productController = Get.find();


  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      double value = controller.offset / 250;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      return Scaffold(
          appBar: AppBar(
            title: Text("Home",style: GoogleFonts.getFont('Cairo',color: Colors.black),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(onPressed: ()=>Get.to(()=>Add_products(data: null,)), icon: Icon(Icons.add_business_outlined,color: Colors.black,))
            ],
          ),
          body: _body(size));



  }

  _body(Size size){
    return Container(
      child: RefreshIndicator(
        onRefresh: ()=> _productController.fetch_get_Allproducts(),
        child: Obx(() {
          if(_productController.products.isEmpty){
            _productController.fetch_get_Allproducts();
          }
          return _productController.products.isEmpty ?  Container(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  // colors: Colors.amber,
                  strokeWidth: 5,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.black,
                ),
              ),
            ),
          ) :
          GridView.builder(
              controller: controller,
              itemCount: _productController.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:  size.width > 800? 2 :1,mainAxisExtent: 165,mainAxisSpacing: 15),
              shrinkWrap: true,
              //       physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                double scale = 1.0;
                if (topContainer > 0.5) {
                  scale = index + 0.5 - topContainer;
                  if (scale < 0) {
                    scale = 0;
                  } else if (scale > 1) {
                    scale = 1;
                  }
                }
                var item = _productController.products[index];
                return Opacity(
                  opacity: scale,
                  child: Transform(
                    transform: Matrix4.identity()..scale(scale, scale),
                    alignment: Alignment.bottomCenter,
                    child: Align(
                      heightFactor: 0.7,
                      alignment: Alignment.topCenter,
                      child:  Container(
                          height: kIsWeb ? size.height * 0.280: size.height * 0.225,
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                            child: InkWell(
                              splashColor: Colors.cyanAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '0',
                                              style: Theme.of(context).textTheme.headline1!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " ${item.price.toString() +  ' جـــنية ' }",
                                              style: Theme.of(context).textTheme.headline1!.copyWith(
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp),
                                            ),

                                          ],
                                        ),),
                                      Text(
                                        item.name,
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end,
                                      ),
                                      // Text(
                                      //   _productController.food_category[index].description,
                                      //   maxLines: 1,
                                      //   style:  TextStyle(
                                      //     overflow: TextOverflow.ellipsis,
                                      //       fontSize: 13, fontWeight: FontWeight.bold),
                                      //   textAlign: TextAlign.end,
                                      // ),
                                      //  Flexible(
                                      //    child: SizedBox(
                                      //      width: 150,
                                      //      child: Text(
                                      //        _productController.categoryDataSubLines[index].categoryDescription,
                                      // //     overflow: TextOverflow.ellipsis,
                                      //        maxLines: 3,
                                      //       style: const TextStyle(fontSize: 17, color: Colors.grey),
                                      //      ),
                                      //    ),
                                      //  ),
                                      Row(
                                        children: [
                                          Text('100'),
                                          SizedBox(width: 15,),
                                          RatingBarIndicator(
                                            rating:3.5,
                                            itemBuilder: (context, index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 17.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                    ],
                                  ),
                                  Flexible(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25.0),
                                        //       child: Image.network( url_image + item.image)
                                        child: Image.network(url_image + item.image)
                                    ),
                                  ),
                                  Material(
                                    child: InkWell(
                                      onTap: ()=>Get.to(()=>Add_products(data: item,)),
                                      child: Icon(Icons.edit,color:Colors.blue
                                        ,size: size.width > 900 ? 10.w :  20.w,),
                                      splashColor: Colors.amberAccent,
                                      highlightColor: Colors.green,
                                    ),
                                  ),

                                ],
                              ),
                              onTap: () {
                                // var item = _productController.food_category[index] ;
                                // _productController.get_food_category(item.category , 0);
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodDetailPage(item: item,)));
                              },
                            ),
                          )),),
                  ),
                );
              });
        } ),
      ),
    ) ;
  }

  _baseDialog(context,id,image_url) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('delete'),
        content: Text('delete data'),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(false); // dismisses only the dialog and returns false
            },
            child: Text('cancel'),
          ),
          TextButton(
            onPressed: () {

           //   _productsController.delete_food(id,image_url);
              Navigator.of(context, rootNavigator: true).pop(false);

            },
            child: Text('ok'.tr),
          ),
        ],
      ),
    );
  }

}
