import 'package:eato/data/model/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_model.dart';

abstract class GuestMenuByRestaurantIdState {}

class GuestMenuByRestaurantIdInitial extends GuestMenuByRestaurantIdState {}

class GuestMenuByRestaurantIdLoading extends GuestMenuByRestaurantIdState {}

class GuestMenuByRestaurantIdSuccess extends GuestMenuByRestaurantIdState {
  final GuestMenuByRestaurantIdModel data;

  GuestMenuByRestaurantIdSuccess(this.data);
}

class GuestMenuByRestaurantIdFailure extends GuestMenuByRestaurantIdState {
  final String error;

  GuestMenuByRestaurantIdFailure(this.error);
}
