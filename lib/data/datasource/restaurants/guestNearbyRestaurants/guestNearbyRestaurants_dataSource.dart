import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_model.dart';

abstract class GuestNearByRestaurantsRemoteDataSource {
  Future<GuestNearByRestaurantsModel> guestNearByRestaurants(Map<String, dynamic> params);
}

class GuestNearByRestaurantsRemoteDataSourceImpl
    implements GuestNearByRestaurantsRemoteDataSource {
  final Dio client;

  GuestNearByRestaurantsRemoteDataSourceImpl({required this.client});

  @override
  Future<GuestNearByRestaurantsModel> guestNearByRestaurants(Map<String, dynamic> params) async {
    try {
      final double latitude = params['latitude'];
      final double longitude = params['longitude'];
      final String postalCode = params['postalCode'];
      final int page = params['page'];
      final int size = params['size'];

      final url = '$baseUrl2${guestNearbyRestaurantsUrl(latitude, longitude, postalCode, page, size)}';

      final response = await client.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('response of GuestNearByRestaurants:: $response');
        return GuestNearByRestaurantsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load GuestNearByRestaurants data: ${e.toString()}');
    }
  }
}
