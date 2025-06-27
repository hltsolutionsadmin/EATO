import 'package:eato/data/model/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_model.dart';

abstract class GuestNearByRestaurantsState {}

class GuestNearByRestaurantsInitial extends GuestNearByRestaurantsState {}

class GuestNearByRestaurantsLoading extends GuestNearByRestaurantsState {}

class GuestNearByRestaurantsSuccess extends GuestNearByRestaurantsState {
  final GuestNearByRestaurantsModel data;
  GuestNearByRestaurantsSuccess(this.data);
}

class GuestNearByRestaurantsFailure extends GuestNearByRestaurantsState {
  final String message;
  GuestNearByRestaurantsFailure(this.message);
}
