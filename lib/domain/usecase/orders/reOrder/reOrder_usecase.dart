import 'package:eato/data/model/orders/reOrder/reOrder_model.dart';
import 'package:eato/domain/repository/orders/reOrder/reOrder_repository.dart';

class ReOrderUseCase {
  final ReOrderRepository repository;

  ReOrderUseCase({required this.repository});

  Future<ReOrderModel> call(int orderId) async {
    return await repository.reOrder(orderId);
  }
}
