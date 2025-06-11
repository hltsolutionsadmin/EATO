import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/address/defaultAddress/post/defaultAddress_model.dart';


abstract class DefaultAddressRemoteDataSource {
  Future<DefaultAddressModel> defaultAddress(
int addressId
  );
}

class DefaultAddressRemoteDataSourceImpl implements DefaultAddressRemoteDataSource {
  final Dio client;

  DefaultAddressRemoteDataSourceImpl({required this.client});

  @override
  Future<DefaultAddressModel> defaultAddress(int addressId) async {
    try {
      final response = await client.post(
        '$baseUrl${'$defaultAddressUrl/$addressId'}',
      );

      print('DefaultAddress Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DefaultAddressModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('DefaultAddress Error: $e');
      throw Exception('DefaultAddress failed: ${e.toString()}');
    }
  }
}
