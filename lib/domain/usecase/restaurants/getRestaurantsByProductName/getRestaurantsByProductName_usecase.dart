import 'package:eato/data/model/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_model.dart';
import 'package:eato/domain/repository/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_repository.dart';

class GetRestaurantsByProductNameUseCase {
  final GetRestaurantsByProductNameRepository repository;

  GetRestaurantsByProductNameUseCase({required this.repository});

  Future<GetRestaurantsByProductNameModel> call(Map<String, dynamic> params) {
    return repository.getRestaurantsByProductName(params);
  }
}
