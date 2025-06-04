import 'package:eato/domain/usecase/orders/createOrder/createOrder_usecase.dart';
import 'package:eato/presentation/cubit/orders/createOrder/createOrder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUseCase useCase;

  CreateOrderCubit(this.useCase) : super(CreateOrderInitial());

  Future<void> createOrder() async {
    emit(CreateOrderLoading());
    try {
      final Order = await useCase();
      emit(CreateOrderLoaded(Order));
    } catch (e) {
      emit(CreateOrderError(e.toString()));
    }
  }
}