import 'package:eato/data/model/address/deleteAddress/deleteAddress_model.dart';

abstract class DeleteAddressState {}

class DeleteAddressInitial extends DeleteAddressState {}

class DeleteAddressLoading extends DeleteAddressState {}

class DeleteAddressSuccess extends DeleteAddressState {
  final DeleteAddressModel response;

  DeleteAddressSuccess(this.response);
}

class DeleteAddressFailure extends DeleteAddressState {
  final String error;

  DeleteAddressFailure(this.error);
}
