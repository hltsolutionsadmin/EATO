import 'package:eato/data/model/orders/createOrder/createOrder_model.dart';

abstract class CreateOrderRepository {
  Future<CreateOrderModel> createOrder();
}
