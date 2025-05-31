import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_model.dart';

abstract class GetRestaurantsByProductNameRemoteDataSource {
  Future<GetRestaurantsByProductNameModel> getRestaurantsByProductName(
      Map<String, dynamic> params);
}

class GetRestaurantsByProductNameRemoteDataSourceImpl
    implements GetRestaurantsByProductNameRemoteDataSource {
  final Dio client;

  GetRestaurantsByProductNameRemoteDataSourceImpl({required this.client});

  @override
  Future<GetRestaurantsByProductNameModel> getRestaurantsByProductName(
      Map<String, dynamic> params) async {
    try {
      final String productName = params['productName'];
      final double latitude = params['latitude'];
      final double longitude = params['longitude'];
      final String postalCode = params['postalCode'];
      final int page = params['page'];
      final int size = params['size'];
      final url =
          '$baseUrl${getRestaurantsByProductNameUrl(productName,latitude, longitude, postalCode, page, size)}';

      final response = await client.request(
        url,
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        print('response of GetRestaurantsByProductName:: $response');
        return GetRestaurantsByProductNameModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load GetRestaurantsByProductName data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Failed to load GetRestaurantsByProductName data: ${e.toString()}');
    }
  }
}
