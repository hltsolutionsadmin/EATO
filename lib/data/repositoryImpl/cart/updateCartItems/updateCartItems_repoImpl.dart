import 'package:eato/data/datasource/cart/updateCartItems/updateCartItems_dataSource.dart';
import 'package:eato/data/model/cart/updateCartItems/updateCartItems_model.dart';
import 'package:eato/domain/repository/cart/updateCartItems/updateCartItems_repository.dart';

class UpdateCartItemsRepositoryImpl implements UpdateCartItemsRepository {
  final UpdateCartItemsRemoteDataSource remoteDataSource;

  UpdateCartItemsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UpdateCartItemsModel> updateCartItems(Map<String, dynamic> payload, String cartId) {
    return remoteDataSource.updateCartItems(payload, cartId);
  }
}
