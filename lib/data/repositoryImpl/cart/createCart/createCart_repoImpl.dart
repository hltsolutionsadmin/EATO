

import 'package:eato/data/datasource/cart/createCart/createCart_dataSource.dart';
import 'package:eato/data/model/cart/createCart/createCart_model.dart';
import 'package:eato/domain/repository/cart/createCart/createCart_repository.dart';

class CreateCartRepositoryImpl implements CreateCartRepository {
  final CreateCartRemoteDataSource remoteDataSource;

  CreateCartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CreateCartModel> createCart() {
    return remoteDataSource.createCart();
  }
}
