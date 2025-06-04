import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';

abstract class OrderHistoryRepository {
  Future<OrderHistoryModel> orderHistory();
}