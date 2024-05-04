import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tset_shope/controllers/cubit/products_cubit.dart';
import 'package:tset_shope/home_page.dart';
import 'package:tset_shope/home_page_cubit.dart';
import 'package:tset_shope/test.dart';

import 'controllers/product_cntrollers.dart';

void main() async {
  await GetStorage.init();
  ProductsController _productController = Get.put(ProductsController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Products_cubit(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              // navigatorKey: navigatorKey,
              // themeMode: ProductController().getThemeMode(),
              // theme: CustomTheme.lightTheme,
              // darkTheme: CustomTheme.darkTheme,
              // translations: MyTranslation(),
              // locale:  Locale(ProductController().getlanguage()),
            // home: Home_page(),
             home: SpeechSampleApp(),
        //     home: Home_page_Cubit(),
            );
          }),
    );
  }
}


