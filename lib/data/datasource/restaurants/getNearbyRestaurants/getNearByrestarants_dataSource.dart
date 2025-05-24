
import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/restaurants/getNearbyRestaurants/getNearByrestarants_model.dart';

abstract class GetNearByRestaurantsRemoteDataSource {
  Future<GetNearByRestaurantsModel> getNearByRestaurants(Map<String, dynamic> params);
}


class GetNearByRestaurantsRemoteDataSourceImpl
    implements GetNearByRestaurantsRemoteDataSource {
  final Dio client;

  GetNearByRestaurantsRemoteDataSourceImpl({required this.client});

  @override
  Future<GetNearByRestaurantsModel> getNearByRestaurants(Map<String, dynamic> params) async {
    try {
      final double latitude = params['latitude'];
      final double longitude = params['longitude'];
      final String postalCode = params['postalCode'];
      final int page = params['page'];
      final int size = params['size'];

      final url = '$baseUrl2${getNearbyRestaurantsUrl(latitude, longitude, postalCode, page, size)}';

      final response = await client.request(
        url,
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        print('response of getNearByRestaurants:: $response');
        return GetNearByRestaurantsModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load getNearByRestaurants data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load getNearByRestaurants data: ${e.toString()}');
    }
  }
}
