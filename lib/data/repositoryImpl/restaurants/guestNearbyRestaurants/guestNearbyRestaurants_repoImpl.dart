import 'package:eato/data/datasource/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_dataSource.dart';
import 'package:eato/data/model/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_model.dart';
import 'package:eato/domain/repository/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_repository.dart';

class GuestNearByRestaurantsRepositoryImpl implements GuestNearByRestaurantsRepository {
  final GuestNearByRestaurantsRemoteDataSource remoteDataSource;

  GuestNearByRestaurantsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GuestNearByRestaurantsModel> guestNearByRestaurants(Map<String, dynamic> params) {
    return remoteDataSource.guestNearByRestaurants(params);
  }
}
