import 'package:eato/data/model/cart/productsAddToCart/productsAddtoCart_model.dart';

abstract class ProductsAddToCartRepository {
  Future<List<ProductsAddToCartModel>> productsAddToCart(
    Map<String, dynamic> payload, {
    bool forceReplace = false,
  });
}

