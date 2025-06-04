import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';

abstract class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final OrderHistoryModel model;

  OrderHistoryLoaded(this.model);
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  OrderHistoryError(this.message);
}