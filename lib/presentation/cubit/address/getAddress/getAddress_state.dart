import 'package:eato/data/model/address/getAddress/getAddress_model.dart';

abstract class GetAddressState {}

class GetAddressInitial extends GetAddressState {}

class GetAddressLoading extends GetAddressState {}

class GetAddressSuccess extends GetAddressState {
  final GetAddressModel addressModel;
  GetAddressSuccess(this.addressModel);
}

class GetAddressFailure extends GetAddressState {
  final String error;
  GetAddressFailure(this.error);
}
