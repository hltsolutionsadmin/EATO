import 'package:eato/data/model/address/defaultAddress/get/getDefaultAddress_model.dart';

abstract class AddressSavetoCartRepository {
  Future<AddressSavetoCartModel> addressSavetoCart(int addressId);
}
