import 'package:eato/data/model/cart/productsAddToCart/productsAddtoCart_model.dart';

abstract class ProductsAddToCartRepository {
  Future<List<ProductsAddToCartModel>> productsAddToCart(List<Map<String, dynamic>>payload);
}

