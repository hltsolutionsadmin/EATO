import 'package:eato/domain/usecase/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'getRestaurantsByProductName_state.dart';

class GetRestaurantsByProductNameCubit extends Cubit<GetRestaurantsByProductNameState> {
  final GetRestaurantsByProductNameUseCase useCase;

  GetRestaurantsByProductNameCubit(this.useCase) : super(GetRestaurantsByProductNameInitial());

  Future<void> fetchRestaurantsByProductName(Map<String, dynamic> params) async {
    try {
      emit(GetRestaurantsByProductNameLoading());
      final result = await useCase(params);
      emit(GetRestaurantsByProductNameSuccess(result));
    } catch (e) {
      emit(GetRestaurantsByProductNameFailure(e.toString()));
    }
  }
}
