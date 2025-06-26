import 'package:eato/data/model/orders/createOrder/createOrder_model.dart';
import 'package:eato/domain/repository/orders/createOrder/createOrder_repository.dart';

class CreateOrderUseCase {
  final CreateOrderRepository repository;

  CreateOrderUseCase({required this.repository});

  Future<CreateOrderModel> call(dynamic body) async {
    return await repository.createOrder(body);
  }
}
