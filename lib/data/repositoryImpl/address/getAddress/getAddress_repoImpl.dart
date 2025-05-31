import 'package:eato/data/datasource/address/getAddress/getAddress_dataSource.dart';
import 'package:eato/data/model/address/getAddress/getAddress_model.dart';
import 'package:eato/domain/repository/address/getAddress/getAddress_repository.dart';

class GetAddressRepositoryImpl implements GetAddressRepository {
  final GetAddressRemoteDataSource remoteDataSource;

  GetAddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GetAddressModel> getAddress() async {
    return await remoteDataSource.getAddress();
  }
}
