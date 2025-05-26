import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/cart/updateCartItems/updateCartItems_model.dart';

abstract class UpdateCartItemsRemoteDataSource {
  Future<UpdateCartItemsModel> updateCartItems(
      Map<String, dynamic> payload, String cartId);
}

class UpdateCartItemsRemoteDataSourceImpl
    implements UpdateCartItemsRemoteDataSource {
  final Dio client;

  UpdateCartItemsRemoteDataSourceImpl({required this.client});

  @override
  Future<UpdateCartItemsModel> updateCartItems(
      Map<String, dynamic> payload, String cartId) async {
    try {
      final response = await client.post(
        '$baseUrl${updateCartItemsUrl(cartId)}',
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('UpdateCartItems Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateCartItemsModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to UpdateCartItems. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('UpdateCartItems Error: $e');
      throw Exception('UpdateCartItems failed: ${e.toString()}');
    }
  }
}
