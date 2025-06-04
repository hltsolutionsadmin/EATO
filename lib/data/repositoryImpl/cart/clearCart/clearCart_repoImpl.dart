import 'package:eato/data/datasource/cart/clearCart/clearCart_dataSource.dart';
import 'package:eato/data/model/cart/clearCart/clearCart_model.dart';
import 'package:eato/domain/repository/cart/clearCart/clearCart_repository.dart';

class ClearCartRepositoryImpl implements ClearCartRepository {
  final ClearCartRemoteDataSource remoteDataSource;

  ClearCartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ClearCartModel> clearCart() {
    return remoteDataSource.clearCart();
  }
}
