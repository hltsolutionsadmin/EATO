import 'package:eato/data/datasource/address/defaultAddress/get/getDefaultAddress_dataSource.dart';
import 'package:eato/data/model/address/defaultAddress/get/getDefaultAddress_model.dart';
import 'package:eato/domain/repository/address/defaultAddress/get/getDefaultAddress_repository.dart';

class AddressSavetoCartRepositoryImpl implements AddressSavetoCartRepository {
  final AddressSavetoCartRemoteDataSource remoteDataSource;

  AddressSavetoCartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AddressSavetoCartModel> addressSavetoCart(int addressId) {
    return remoteDataSource.addressSavetoCart(addressId);
  }
}
