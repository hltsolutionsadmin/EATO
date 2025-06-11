import 'package:eato/domain/usecase/cart/clearCart/clearCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/clearCart/clearCart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearCartCubit extends Cubit<ClearCartState> {
  final ClearCartUseCase clearCartUseCase;

  ClearCartCubit( this.clearCartUseCase) : super(ClearCartInitial());

   clearCart() async {
    emit(ClearCartLoading());
    try {
      final result = await clearCartUseCase();
      emit(ClearCartSuccess(result));
    } catch (e) {
      emit(ClearCartFailure(e.toString()));
    }
  }
}
