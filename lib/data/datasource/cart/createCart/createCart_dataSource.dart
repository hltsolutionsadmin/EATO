import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/cart/createCart/createCart_model.dart';

abstract class CreateCartRemoteDataSource {
  Future<CreateCartModel> createCart();
}

class CreateCartRemoteDataSourceImpl implements CreateCartRemoteDataSource {
  final Dio client;

  CreateCartRemoteDataSourceImpl({required this.client});

  @override
  Future<CreateCartModel> createCart() async {
    try {
      final response = await client.post(
        '$baseUrl$createCartUrl',
      );

      print('CreateCart Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateCartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('CreateCart Error: $e');
      throw Exception('CreateCart failed: ${e.toString()}');
    }
  }
}
