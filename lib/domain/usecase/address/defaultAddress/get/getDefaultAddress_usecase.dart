import 'package:eato/data/model/address/defaultAddress/get/getDefaultAddress_model.dart';
import 'package:eato/domain/repository/address/defaultAddress/get/getDefaultAddress_repository.dart';

class AddressSavetoCartUseCase {
  final AddressSavetoCartRepository repository;

  AddressSavetoCartUseCase({required this.repository});

  Future<AddressSavetoCartModel> call(int addressId) {
    return repository.addressSavetoCart(addressId);
  }
}
