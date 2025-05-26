import 'package:eato/domain/usecase/location/location_usecase.dart';
import 'package:eato/presentation/cubit/location/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationUsecase usecase;
  final String apiKey = 'AIzaSyDRYGEGXZ3PBObX8dqhr6nJ3vzx58-Bjd4';
  final String key = 'AIzaSyDRYGEGXZ3PBObX8dqhr6nJ3vzx58-Bjd4';
  final String? latitude;

  LocationCubit({required this.usecase, this.latitude})
      : super(LocationInitial());

  Future<void> searchLocation(String text) async {
    emit(LocationLoading());
    try {
      final result = await usecase.call(text, apiKey);
      print(
          "Search Location Result: ${result.predictions?[0].placeId} status: ${result.status}");
      final responce =
          await usecase.latlang(result.predictions![0].placeId!, key);

      if (result.status == "OK") {
        print('result of search loaction : ${result.predictions?[0].placeId}');
        // await latlangSearch(result.predictions![0].placeId!);
      }
      emit(LocationLoaded(model: result, latLangModel: responce));
    } catch (e) {
      emit(LocationFailure(message: e.toString()));
    }
  }
}
