import 'package:eato/data/model/address/defaultAddress/post/defaultAddress_model.dart';

abstract class DefaultAddressState {}

class DefaultAddressInitial extends DefaultAddressState {}

class DefaultAddressLoading extends DefaultAddressState {}

class DefaultAddressSuccess extends DefaultAddressState {
  final DefaultAddressModel defaultAddressModel;

  DefaultAddressSuccess({required this.defaultAddressModel});
}

class DefaultAddressFailure extends DefaultAddressState {
  final String error;

  DefaultAddressFailure({required this.error});
}
