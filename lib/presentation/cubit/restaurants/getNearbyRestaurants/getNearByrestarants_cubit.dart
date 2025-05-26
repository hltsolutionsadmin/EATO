
import 'package:eato/domain/usecase/restaurants/getNearbyRestaurants/getNearByrestarants_usecase.dart';
import 'package:eato/presentation/cubit/restaurants/getNearbyRestaurants/getNearByrestarants_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetNearbyRestaurantsCubit extends Cubit<GetNearbyRestaurantsState> {
  final GetNearByRestaurantsUseCase getNearbyRestaurantsUseCase;

  GetNearbyRestaurantsCubit({required this.getNearbyRestaurantsUseCase})
      : super(GetNearbyRestaurantsInitial());

  Future<void> fetchNearbyRestaurants(Map<String, dynamic> params) async {
    emit(GetNearbyRestaurantsLoading());
    try {
      final result = await getNearbyRestaurantsUseCase(params);
      emit(GetNearbyRestaurantsLoaded(result));
    } catch (e) {
      emit(GetNearbyRestaurantsError(e.toString()));
    }
  }
}
