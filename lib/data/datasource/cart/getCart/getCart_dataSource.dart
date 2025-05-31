import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/cart/getCart/getCart_model.dart';


abstract class GetCartRemoteDataSource {
  Future<GetCartModel> getCart();
}

class GetCartRemoteDataSourceImpl
    implements GetCartRemoteDataSource {
  final Dio client;

  GetCartRemoteDataSourceImpl({required this.client});

  @override
  Future<GetCartModel> getCart() async {
    try {
      final response = await client.request(
        '$baseUrl$getCartUrl',
        options: Options(method: 'GET'),
      );
      if (response.statusCode == 200) {
        print('responce of GetCart:: $response');
        return GetCartModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load GetCart data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load GetCart data: ${e.toString()}');
    }
  }
}
