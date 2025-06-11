import 'package:eato/domain/usecase/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_usecase.dart';
import 'package:eato/presentation/cubit/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMenuByRestaurantIdCubit extends Cubit<GetMenuByRestaurantIdState> {
  final GetMenuByRestaurantIdUseCase useCase;

  GetMenuByRestaurantIdCubit(this.useCase) : super(GetMenuByRestaurantIdInitial());

  Future<void> fetchMenu(Map<String, dynamic> params) async {
    print(params);
    emit(GetMenuByRestaurantIdLoading());
    try {
      final result = await useCase(params);
      emit(GetMenuByRestaurantIdLoaded(result));
    } catch (e) {
      emit(GetMenuByRestaurantIdError(e.toString()));
    }
  }
}
