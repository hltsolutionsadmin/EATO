
import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/cart/clearCart/clearCart_model.dart';

abstract class ClearCartRemoteDataSource {
  Future<ClearCartModel> clearCart();
}

class ClearCartRemoteDataSourceImpl implements ClearCartRemoteDataSource {
  final Dio client;

  ClearCartRemoteDataSourceImpl({required this.client});

  @override
  Future<ClearCartModel> clearCart() async {
    try {
      final response = await client.delete(
        '$baseUrl$clearCartUrl',
      );

      print('ClearCart Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClearCartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to ClearCart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('ClearCart Error: $e');
      throw Exception('ClearCart failed: ${e.toString()}');
    }
  }
}