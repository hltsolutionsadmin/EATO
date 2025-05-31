import 'package:eato/data/model/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_model.dart';

abstract class GetRestaurantsByProductNameState {}

class GetRestaurantsByProductNameInitial extends GetRestaurantsByProductNameState {}

class GetRestaurantsByProductNameLoading extends GetRestaurantsByProductNameState {}


class GetRestaurantsByProductNameSuccess extends GetRestaurantsByProductNameState {
  final GetRestaurantsByProductNameModel model;
  GetRestaurantsByProductNameSuccess(this.model);
}

class GetRestaurantsByProductNameFailure extends GetRestaurantsByProductNameState {
  final String error;
  GetRestaurantsByProductNameFailure(this.error);
}
