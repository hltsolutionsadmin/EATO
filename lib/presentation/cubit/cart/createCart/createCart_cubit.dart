import 'package:eato/domain/usecase/cart/createCart/createCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/createCart/createCart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCartCubit extends Cubit<CreateCartState> {
  final CreateCartUseCase useCase;

  CreateCartCubit(this.useCase) : super(CreateCartInitial());

  Future<void> createCart() async {
    emit(CreateCartLoading());
    try {
      final cart = await useCase();
      emit(CreateCartLoaded(cart));
    } catch (e) {
      emit(CreateCartError(e.toString()));
    }
  }
}
