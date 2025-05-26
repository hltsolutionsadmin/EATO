import 'package:eato/data/model/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_model.dart';

abstract class GetMenuByRestaurantIdState {}

class GetMenuByRestaurantIdInitial extends GetMenuByRestaurantIdState {}

class GetMenuByRestaurantIdLoading extends GetMenuByRestaurantIdState {}

class GetMenuByRestaurantIdLoaded extends GetMenuByRestaurantIdState {
  final GetMenuByRestaurantIdModel model;

  GetMenuByRestaurantIdLoaded(this.model);
}

class GetMenuByRestaurantIdError extends GetMenuByRestaurantIdState {
  final String message;

  GetMenuByRestaurantIdError(this.message);
}
