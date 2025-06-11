import 'package:eato/data/datasource/address/deleteAddress/deleteAddress_dataSource.dart';
import 'package:eato/data/model/address/deleteAddress/deleteAddress_model.dart';
import 'package:eato/domain/repository/address/deleteAddress/deleteAddress_repository.dart';

class DeleteAddressRepositoryImpl implements DeleteAddressRepository {
  final DeleteAddressRemoteDataSource remoteDataSource;

  DeleteAddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DeleteAddressModel> deleteAddress(int addressId) async {
    return await remoteDataSource.DeleteAddress(addressId);
  }
}
