
import 'package:tset_shope/modells/m_products.dart';

abstract class Products_State {}
class ProductInsitial extends Products_State{}
class fetch_Products extends Products_State {
  final List<MProducts> data;
  fetch_Products(this.data);
}