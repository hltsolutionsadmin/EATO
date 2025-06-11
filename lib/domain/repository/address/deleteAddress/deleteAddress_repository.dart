import 'package:eato/data/model/address/deleteAddress/deleteAddress_model.dart';

abstract class DeleteAddressRepository {
  Future<DeleteAddressModel> deleteAddress(int addressId);
}
