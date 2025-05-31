import 'package:eato/data/model/address/getAddress/getAddress_model.dart';
import 'package:eato/domain/repository/address/getAddress/getAddress_repository.dart';

class GetAddressUseCase {
  final GetAddressRepository repository;

  GetAddressUseCase({required this.repository});

  Future<GetAddressModel> call() async {
    return await repository.getAddress();
  }
}
