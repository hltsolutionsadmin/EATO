import 'package:eato/data/model/orders/createOrder/createOrder_model.dart';

abstract class CreateOrderState {}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderLoaded extends CreateOrderState {
  final CreateOrderModel order;

  CreateOrderLoaded(this.order);
}

class CreateOrderError extends CreateOrderState {
  final String message;

  CreateOrderError(this.message);
}