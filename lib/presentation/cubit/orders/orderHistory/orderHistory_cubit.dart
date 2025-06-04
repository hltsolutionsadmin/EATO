import 'package:eato/domain/usecase/orders/orderHistory/orderHistory_usecase.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final OrderHistoryUseCase useCase;

  OrderHistoryCubit(this.useCase) : super(OrderHistoryInitial());

  Future<void> fetchCart() async {
    emit(OrderHistoryLoading());
    try {
      final cart = await useCase.execute();
      emit(OrderHistoryLoaded(cart));
    } catch (e) {
      emit(OrderHistoryError(e.toString()));
    }
  }
}
