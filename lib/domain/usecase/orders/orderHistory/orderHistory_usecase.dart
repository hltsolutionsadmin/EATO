import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:eato/domain/repository/orders/orderHistory/orderHistory_repository.dart';

class OrderHistoryUseCase {
  final OrderHistoryRepository repository;

  OrderHistoryUseCase({required this.repository});

  Future<OrderHistoryModel> execute() {
    return repository.orderHistory();
  }
}
