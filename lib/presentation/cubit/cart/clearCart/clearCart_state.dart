import 'package:eato/data/model/cart/clearCart/clearCart_model.dart';

abstract class ClearCartState {}

class ClearCartInitial extends ClearCartState {}

class ClearCartLoading extends ClearCartState {}

class ClearCartSuccess extends ClearCartState {
  final ClearCartModel model;

  ClearCartSuccess(this.model);
}

class ClearCartFailure extends ClearCartState {
  final String error;

  ClearCartFailure(this.error);
}
