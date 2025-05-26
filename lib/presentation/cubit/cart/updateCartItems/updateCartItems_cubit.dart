import 'package:eato/domain/usecase/cart/updateCartItems/updateCartItems_usecase.dart';
import 'package:eato/presentation/cubit/cart/updateCartItems/updateCartItems_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCartItemsCubit extends Cubit<UpdateCartItemsState> {
  final UpdateCartItemsUseCase updateCartItemsUseCase;

  UpdateCartItemsCubit( this.updateCartItemsUseCase) : super(UpdateCartItemsInitial());

  Future<void> updateCartItem(Map<String, dynamic> payload, String cartId) async {
    emit(UpdateCartItemsLoading());
    try {
      final result = await updateCartItemsUseCase(payload, cartId);
      emit(UpdateCartItemsSuccess(result));
    } catch (e) {
      emit(UpdateCartItemsFailure(e.toString()));
    }
  }
}
