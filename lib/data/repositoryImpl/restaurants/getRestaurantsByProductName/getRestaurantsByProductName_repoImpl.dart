import 'package:eato/data/datasource/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_dataSource.dart';
import 'package:eato/data/model/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_model.dart';
import 'package:eato/domain/repository/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_repository.dart';

class GetRestaurantsByProductNameRepositoryImpl implements GetRestaurantsByProductNameRepository {
  final GetRestaurantsByProductNameRemoteDataSource remoteDataSource;

  GetRestaurantsByProductNameRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GetRestaurantsByProductNameModel> getRestaurantsByProductName(Map<String, dynamic> params) {
    return remoteDataSource.getRestaurantsByProductName(params);
  }
}
