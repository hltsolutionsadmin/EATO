import 'package:eato/data/model/cart/clearCart/clearCart_model.dart';
import 'package:eato/domain/repository/cart/clearCart/clearCart_repository.dart';

class ClearCartUseCase {
  final ClearCartRepository repository;

  ClearCartUseCase({required this.repository});

  Future<ClearCartModel> call() {
    return repository.clearCart();
  }
}
