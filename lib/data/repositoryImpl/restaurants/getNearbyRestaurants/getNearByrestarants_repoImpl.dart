import 'package:eato/data/datasource/restaurants/getNearbyRestaurants/getNearByrestarants_dataSource.dart';
import 'package:eato/data/model/restaurants/getNearbyRestaurants/getNearByrestarants_model.dart';
import 'package:eato/domain/repository/restaurants/getNearbyRestaurants/getNearByrestarants_repository.dart';

class GetNearByRestaurantsRepositoryImpl implements GetNearByRestaurantsRepository {
  final GetNearByRestaurantsRemoteDataSource remoteDataSource;

  GetNearByRestaurantsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GetNearByRestaurantsModel> getNearByRestaurants(Map<String, dynamic> params) {
    return remoteDataSource.getNearByRestaurants(params);
  }
}
