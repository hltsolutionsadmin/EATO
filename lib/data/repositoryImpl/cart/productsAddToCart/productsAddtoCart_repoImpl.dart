import 'package:eato/data/datasource/cart/productsAddToCart/productsAddtoCart_dataSource.dart';
import 'package:eato/data/model/cart/productsAddToCart/productsAddtoCart_model.dart';
import 'package:eato/domain/repository/cart/productsAddToCart/productsAddtoCart_repository.dart';

class ProductsAddToCartRepositoryImpl implements ProductsAddToCartRepository {
  final ProductsAddToCartRemoteDataSource remoteDataSource;

  ProductsAddToCartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductsAddToCartModel>> productsAddToCart(List<Map<String, dynamic>> payload,{
    bool forceReplace = false,
  }) {
    return remoteDataSource.productsAddToCart(payload);
  }
}
