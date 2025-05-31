import 'package:eato/data/datasource/cart/getCart/getCart_dataSource.dart';
import 'package:eato/data/model/cart/getCart/getCart_model.dart';
import 'package:eato/domain/repository/cart/getCart/getCart_repository.dart';

class GetCartRepositoryImpl implements GetCartRepository {
  final GetCartRemoteDataSource remoteDataSource;

  GetCartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GetCartModel> getCart() {
    return remoteDataSource.getCart();
  }
}
