import 'package:eato/data/model/address/saveAddress/saveAddress_model.dart';

abstract class SaveAddressState {}

class SaveAddressInitial extends SaveAddressState {}

class SaveAddressLoading extends SaveAddressState {}

class SaveAddressSuccess extends SaveAddressState {
  final SaveAddressModel model;

  SaveAddressSuccess(this.model);
}

class SaveAddressFailure extends SaveAddressState {
  final String message;

  SaveAddressFailure(this.message);
}
