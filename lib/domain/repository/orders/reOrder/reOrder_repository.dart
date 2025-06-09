import 'package:eato/data/model/orders/reOrder/reOrder_model.dart';

abstract class ReOrderRepository {
  Future<ReOrderModel> reOrder(int orderId);
}
