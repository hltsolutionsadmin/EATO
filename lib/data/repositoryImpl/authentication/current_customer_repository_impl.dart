import 'package:eato/data/datasource/authentication/current_customer_remote_data_source.dart';

import '../../../domain/repository/authentication/current_customer_repository.dart';
import '../../model/authentication/current_customer_model.dart';

class CurrentCustomerRepositoryImpl implements CurrentCustomerRepository {
  final CurrentCustomerRemoteDataSource remoteDataSource;

  CurrentCustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CurrentCustomerModel> getCurrentCustomer() async {
    final model = await remoteDataSource.currentCustomer();
    return CurrentCustomerModel(
      id: model.id,
      roles: model.roles,
      primaryContact: model.primaryContact,
      creationTime: model.creationTime,
      version: model.version,
      registered: model.registered,
    );
  }
}
