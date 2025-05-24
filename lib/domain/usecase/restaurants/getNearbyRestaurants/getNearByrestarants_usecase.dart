import 'package:eato/data/model/restaurants/getNearbyRestaurants/getNearByrestarants_model.dart';
import 'package:eato/domain/repository/restaurants/getNearbyRestaurants/getNearByrestarants_repository.dart';

class GetNearByRestaurantsUseCase {
  final GetNearByRestaurantsRepository repository;

  GetNearByRestaurantsUseCase({required this.repository});

  Future<GetNearByRestaurantsModel> call(Map<String, dynamic> params) {
    return repository.getNearByRestaurants(params);
  }
}
