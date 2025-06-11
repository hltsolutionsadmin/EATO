import 'package:eato/data/model/address/deleteAddress/deleteAddress_model.dart';
import 'package:eato/domain/repository/address/deleteAddress/deleteAddress_repository.dart';

class DeleteAddressUseCase {
  final DeleteAddressRepository repository;

  DeleteAddressUseCase({required this.repository});

  Future<DeleteAddressModel> execute(int addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
