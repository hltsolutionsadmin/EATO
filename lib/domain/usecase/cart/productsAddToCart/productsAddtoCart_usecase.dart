import 'package:eato/data/model/cart/productsAddToCart/productsAddtoCart_model.dart';
import 'package:eato/domain/repository/cart/productsAddToCart/productsAddtoCart_repository.dart';

class ProductsAddToCartUseCase {
  final ProductsAddToCartRepository repository;

  ProductsAddToCartUseCase(this.repository);

  Future<List<ProductsAddToCartModel>> call(
    List<Map<String, dynamic>> payload, {
    bool forceReplace = false,
  }) async {
    return await repository.productsAddToCart(payload, forceReplace: forceReplace);
  }
}
