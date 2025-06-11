import 'package:eato/data/model/address/defaultAddress/post/defaultAddress_model.dart';
import 'package:eato/domain/repository/address/defaultAddress/post/defaultAddress_repository.dart';

class DefaultAddressUseCase {
  final DefaultAddressRepository repository;

  DefaultAddressUseCase({required this.repository});

  Future<DefaultAddressModel> call(int addressId) {
    return repository.setDefaultAddress(addressId);
  }
}
