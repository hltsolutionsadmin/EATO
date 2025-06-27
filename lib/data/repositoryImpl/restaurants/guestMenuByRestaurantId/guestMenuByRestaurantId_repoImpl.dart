import 'package:eato/data/datasource/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_dataSource.dart';
import 'package:eato/data/model/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_model.dart';
import 'package:eato/domain/repository/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_repository.dart';

class GuestMenuByRestaurantIdRepositoryImpl
    implements GuestMenuByRestaurantIdRepository {
  final GuestMenuByRestaurantIdRemoteDataSource remoteDataSource;

  GuestMenuByRestaurantIdRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GuestMenuByRestaurantIdModel> guestMenuByRestaurantId(
      Map<String, dynamic> params) {
    return remoteDataSource.guestMenuByRestaurantId(params);
  }
}
