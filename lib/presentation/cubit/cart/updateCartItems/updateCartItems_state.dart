import 'package:eato/data/model/cart/updateCartItems/updateCartItems_model.dart';

abstract class UpdateCartItemsState {}

class UpdateCartItemsInitial extends UpdateCartItemsState {}

class UpdateCartItemsLoading extends UpdateCartItemsState {}

class UpdateCartItemsSuccess extends UpdateCartItemsState {
  final UpdateCartItemsModel updatedItem;

  UpdateCartItemsSuccess(this.updatedItem);
}

class UpdateCartItemsFailure extends UpdateCartItemsState {
  final String error;

  UpdateCartItemsFailure(this.error);
}
