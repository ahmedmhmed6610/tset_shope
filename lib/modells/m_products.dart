import 'dart:convert';


List<MProducts> mProductsFromJson(String str) => List<MProducts>.from(json.decode(str).map((x) => MProducts.fromJson(x)));

String mProductsToJson(List<MProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MProducts {
  int id;
  String name;
  String price;
  String image;

  MProducts({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory MProducts.fromJson(Map<String, dynamic> json) => MProducts(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "image": image,
  };
}
