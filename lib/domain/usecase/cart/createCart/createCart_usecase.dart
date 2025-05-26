import 'package:eato/data/model/cart/createCart/createCart_model.dart';
import 'package:eato/domain/repository/cart/createCart/createCart_repository.dart';

class CreateCartUseCase {
  final CreateCartRepository repository;

  CreateCartUseCase({required this.repository});

  Future<CreateCartModel> call() async {
    return await repository.createCart();
  }
}
