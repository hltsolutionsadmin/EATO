import 'package:eato/data/model/location/lattitude_longitude_model.dart';
import 'package:eato/data/model/location/location_model.dart';
import 'package:eato/domain/repository/location/location_repo.dart';

class LocationUsecase {
  final LocationRepository repository;
  final LocationRepository latLongRepository;

  LocationUsecase({required this.repository, required this.latLongRepository});

  Future<LocationSearchModel> call(String input, String apiKey) async {
    return await repository.LocationSearch(input, apiKey);
  }

  Future<LatLangModel> latlang(String placeId, String key) async {
    return await latLongRepository.LatlangSearch(placeId, key);
  }
}