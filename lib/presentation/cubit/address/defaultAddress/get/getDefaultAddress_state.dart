import 'package:eato/data/model/address/defaultAddress/get/getDefaultAddress_model.dart';

abstract class AddressSavetoCartState {}

class AddressSavetoCartInitial extends AddressSavetoCartState {}

class AddressSavetoCartLoading extends AddressSavetoCartState {}

class AddressSavetoCartSuccess extends AddressSavetoCartState {
  final AddressSavetoCartModel model;

  AddressSavetoCartSuccess(this.model);
}

class AddressSavetoCartFailure extends AddressSavetoCartState {
  final String message;

  AddressSavetoCartFailure(this.message);
}
