import 'package:eato/data/model/cart/updateCartItems/updateCartItems_model.dart';
import 'package:eato/domain/repository/cart/updateCartItems/updateCartItems_repository.dart';

class UpdateCartItemsUseCase {
  final UpdateCartItemsRepository repository;

  UpdateCartItemsUseCase({required this.repository});

  Future<UpdateCartItemsModel> call(Map<String, dynamic> payload, String cartId) {
    return repository.updateCartItems(payload, cartId);
  }
}
