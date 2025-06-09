import 'package:eato/data/datasource/orders/reOrder/reOrder_dataSource.dart';
import 'package:eato/data/model/orders/reOrder/reOrder_model.dart';
import 'package:eato/domain/repository/orders/reOrder/reOrder_repository.dart';

class ReOrderRepositoryImpl implements ReOrderRepository {
  final ReOrderRemoteDataSource remoteDataSource;

  ReOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ReOrderModel> reOrder(int orderId) async {
    return await remoteDataSource.reOrder(orderId);
  }
}
