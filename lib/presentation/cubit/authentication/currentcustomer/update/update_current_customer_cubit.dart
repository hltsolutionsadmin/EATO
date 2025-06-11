import 'package:eato/domain/usecase/authentication/update_current_customer_usecase.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/update/update_current_customer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCurrentCustomerCubit extends Cubit<UpdateCurrentCustomerState> {
  final UpdateCurrentCustomerUseCase useCase;

  UpdateCurrentCustomerCubit({required this.useCase})
      : super(UpdateCurrentCustomerState());

  Future<void> updateCustomer(Map<String, dynamic> payload) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await useCase(payload);
      emit(state.copyWith(isLoading: false, data: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}