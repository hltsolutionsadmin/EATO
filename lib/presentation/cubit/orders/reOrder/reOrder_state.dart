import 'package:eato/data/model/orders/reOrder/reOrder_model.dart';

abstract class ReOrderState {}

class ReOrderInitial extends ReOrderState {}

class ReOrderLoading extends ReOrderState {}

class ReOrderSuccess extends ReOrderState {
  final ReOrderModel reOrderModel;

  ReOrderSuccess({required this.reOrderModel});
}

class ReOrderFailure extends ReOrderState {
  final String message;

  ReOrderFailure({required this.message});
}
