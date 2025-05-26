import 'package:eato/data/model/cart/getCart/getCart_model.dart';

abstract class GetCartState {}

class GetCartInitial extends GetCartState {}

class GetCartLoading extends GetCartState {}

class GetCartLoaded extends GetCartState {
  final GetCartModel cart;

  GetCartLoaded(this.cart);
}

class GetCartError extends GetCartState {
  final String message;

  GetCartError(this.message);
}
