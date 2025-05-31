import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/address/getAddress/getAddress_model.dart';

abstract class GetAddressRemoteDataSource {
  Future<GetAddressModel> getAddress();
}

class GetAddressRemoteDataSourceImpl
    implements GetAddressRemoteDataSource {
  final Dio client;

  GetAddressRemoteDataSourceImpl({required this.client});

  @override
  Future<GetAddressModel> getAddress() async {
    try {
      final response = await client.request(
        '$baseUrl2$getAddressUrl',
        options: Options(method: 'GET'),
      );
      if (response.statusCode == 200) {
        print('responce of GetAddress:: $response');
        return GetAddressModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load GetAddress data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load GetAddress data: ${e.toString()}');
    }
  }
}
