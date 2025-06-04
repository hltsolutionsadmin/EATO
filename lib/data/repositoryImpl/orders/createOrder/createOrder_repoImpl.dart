import 'package:eato/data/datasource/orders/createOrder/createOrder_dataSource.dart';
import 'package:eato/data/model/orders/createOrder/createOrder_model.dart';
import 'package:eato/domain/repository/orders/createOrder/createOrder_repository.dart';

class CreateOrderRepositoryImpl implements CreateOrderRepository {
  final CreateOrderRemoteDataSource remoteDataSource;

  CreateOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CreateOrderModel> createOrder() {
    return remoteDataSource.createOrder();
  }
}