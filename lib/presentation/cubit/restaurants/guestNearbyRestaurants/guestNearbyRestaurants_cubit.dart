import 'package:eato/domain/usecase/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'guestNearbyRestaurants_state.dart';

class GuestNearByRestaurantsCubit extends Cubit<GuestNearByRestaurantsState> {
  final GuestNearByRestaurantsUseCase useCase;

  GuestNearByRestaurantsCubit(this.useCase)
      : super(GuestNearByRestaurantsInitial());

  Future<void> fetchGuestNearbyRestaurants(Map<String, dynamic> params) async {
    emit(GuestNearByRestaurantsLoading());
    try {
      final result = await useCase(params);
      emit(GuestNearByRestaurantsSuccess(result));
    } catch (e) {
      emit(GuestNearByRestaurantsFailure(e.toString()));
    }
  }
}
