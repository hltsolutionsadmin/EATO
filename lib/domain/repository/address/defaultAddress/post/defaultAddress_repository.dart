import 'package:eato/data/model/address/defaultAddress/post/defaultAddress_model.dart';

abstract class DefaultAddressRepository {
  Future<DefaultAddressModel> setDefaultAddress(int addressId);
}
