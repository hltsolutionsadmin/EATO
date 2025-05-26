import 'package:eato/presentation/cubit/dashboard/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DashBoardCubit extends Cubit<DashBoardState> {
  DashBoardCubit() : super(DashBoardInitial());

  Future<void> fetchLocation() async {
    try {
      emit(DashBoardLoading());

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(DashBoardError("Location services are disabled."));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(DashBoardError("Location permission denied."));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(DashBoardError("Location permission permanently denied."));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      print(
          "$latitude, $longitude, ${place.administrativeArea}, ${place.country}");
      emit(DashBoardLocationFetched(
        latitude: latitude,
        longitude: longitude,
        address: address,
        place: place,
      ));
    } catch (e) {
      emit(DashBoardError("Error fetching location: $e"));
    }
  }
}
