import 'package:eato/domain/usecase/cart/getCart/getCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCartCubit extends Cubit<GetCartState> {
  final GetCartUseCase useCase;

  GetCartCubit(this.useCase) : super(GetCartInitial());

  Future<void> fetchCart() async {
    emit(GetCartLoading());
    try {
      final cart = await useCase.execute();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('cart_id', cart.id ?? 0);
      print("cart id is ${cart.id}");
      emit(GetCartLoaded(cart));
    } catch (e) {
      emit(GetCartError(e.toString()));
    }
  }
}
