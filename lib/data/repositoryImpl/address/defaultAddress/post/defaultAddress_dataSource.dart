import 'package:eato/data/datasource/address/defaultAddress/post/defaultAddress_dataSource.dart';
import 'package:eato/data/model/address/defaultAddress/post/defaultAddress_model.dart';
import 'package:eato/domain/repository/address/defaultAddress/post/defaultAddress_repository.dart';

class DefaultAddressRepositoryImpl implements DefaultAddressRepository {
  final DefaultAddressRemoteDataSource remoteDataSource;

  DefaultAddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DefaultAddressModel> setDefaultAddress(int addressId) {
    return remoteDataSource.defaultAddress(addressId);
  }
}
