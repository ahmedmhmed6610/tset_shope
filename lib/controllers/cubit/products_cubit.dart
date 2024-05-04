
import 'package:bloc/bloc.dart';
import 'package:tset_shope/controllers/cubit/products_state.dart';
import 'package:tset_shope/modells/m_products.dart';
import 'package:tset_shope/services/services.dart';

class Products_cubit extends Cubit<Products_State>{
  Products_cubit() : super(ProductInsitial()){
//    fetch_get_Allproducts();
  }
  var products =<MProducts>[];

  Future fetch_get_Allproducts() async {
    try {
      var _data = await Services.get_Allproducts();
      if (_data != null) {
        products = _data;
        emit(fetch_Products(products));
      }
    } finally{}
  }

}