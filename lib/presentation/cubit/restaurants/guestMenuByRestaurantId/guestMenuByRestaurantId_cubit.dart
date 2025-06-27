import 'package:eato/domain/usecase/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'guestMenuByRestaurantId_state.dart';

class GuestMenuByRestaurantIdCubit extends Cubit<GuestMenuByRestaurantIdState> {
  final GuestMenuByRestaurantIdUseCase useCase;

  GuestMenuByRestaurantIdCubit( this.useCase)
      : super(GuestMenuByRestaurantIdInitial());

  Future<void> fetchGuestMenuByRestaurantId(Map<String, dynamic> params) async {
    emit(GuestMenuByRestaurantIdLoading());
    try {
      final result = await useCase(params);
      emit(GuestMenuByRestaurantIdSuccess(result));
    } catch (e) {
      emit(GuestMenuByRestaurantIdFailure(e.toString()));
    }
  }
}
