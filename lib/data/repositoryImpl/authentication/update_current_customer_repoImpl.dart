
import 'package:eato/data/datasource/authentication/update_current_customer_dataSource.dart';
import 'package:eato/data/model/authentication/update_current_customer_model.dart';
import 'package:eato/domain/repository/authentication/update_current_customer_repository.dart';

class UpdateCurrentCustomerRepositoryImpl implements UpdateCurrentCustomerRepository {
  final UpdateCurrentCustomerRemoteDatasource remoteDatasource;

  UpdateCurrentCustomerRepositoryImpl({required this.remoteDatasource});

  @override
  Future<UpdateCurrentCustomerModel> updateCurrentCustomer(Map<String, dynamic> payload) {
    return remoteDatasource.updateCurrentCustomer(payload: payload);
  }
}
