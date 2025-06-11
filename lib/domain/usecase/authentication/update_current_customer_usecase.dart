
import 'package:eato/data/model/authentication/update_current_customer_model.dart';
import 'package:eato/domain/repository/authentication/update_current_customer_repository.dart';

class UpdateCurrentCustomerUseCase {
  final UpdateCurrentCustomerRepository repository;

  UpdateCurrentCustomerUseCase({required this.repository});

  Future<UpdateCurrentCustomerModel> call(Map<String, dynamic> payload) {
    return repository.updateCurrentCustomer(payload);
  }
}