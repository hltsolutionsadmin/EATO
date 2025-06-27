import 'package:eato/data/model/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_model.dart';
import 'package:eato/domain/repository/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_repository.dart';

class GuestMenuByRestaurantIdUseCase {
  final GuestMenuByRestaurantIdRepository repository;

  GuestMenuByRestaurantIdUseCase({required this.repository});

  Future<GuestMenuByRestaurantIdModel> call(Map<String, dynamic> params) {
    return repository.guestMenuByRestaurantId(params);
  }
}
