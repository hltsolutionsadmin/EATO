import 'package:eato/data/model/address/getAddress/getAddress_model.dart';

abstract class GetAddressRepository {
  Future<GetAddressModel> getAddress();
}
