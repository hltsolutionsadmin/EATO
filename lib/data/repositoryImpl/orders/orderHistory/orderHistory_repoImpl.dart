import 'package:eato/data/datasource/orders/orderHistory/orderHistory_dataSource.dart';
import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:eato/domain/repository/orders/orderHistory/orderHistory_repository.dart';

class OrderHistoryRepositoryImpl implements OrderHistoryRepository {
  final OrderHistoryRemoteDataSource remoteDataSource;

  OrderHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderHistoryModel> orderHistory() {
    return remoteDataSource.orderHistory();
  }
}