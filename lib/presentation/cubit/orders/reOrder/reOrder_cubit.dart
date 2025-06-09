import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eato/domain/usecase/orders/reOrder/reOrder_usecase.dart';
import 'reOrder_state.dart';

class ReOrderCubit extends Cubit<ReOrderState> {
  final ReOrderUseCase usecase;

  ReOrderCubit( this.usecase) : super(ReOrderInitial());

  Future<void> reOrder(int orderId) async {
    emit(ReOrderLoading());
    try {
      final result = await usecase(orderId);
      emit(ReOrderSuccess(reOrderModel: result));
    } catch (e) {
      emit(ReOrderFailure(message: e.toString()));
    }
  }
}
