import 'package:eato/data/model/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_model.dart';

abstract class GetMenuByRestaurantIdRepository {
  Future<GetMenuByRestaurantIdModel> getMenuByRestaurantId(Map<String, dynamic> params);
}
