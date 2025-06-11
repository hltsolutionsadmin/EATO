import 'package:eato/domain/usecase/address/defaultAddress/get/getDefaultAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/defaultAddress/get/getDefaultAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressSavetoCartCubit extends Cubit<AddressSavetoCartState> {
  final AddressSavetoCartUseCase useCase;

  AddressSavetoCartCubit(this.useCase) : super(AddressSavetoCartInitial());

  Future<void> addressSavetoCart(int addressId) async {
    try {
      emit(AddressSavetoCartLoading());
      final result = await useCase(addressId);
      emit(AddressSavetoCartSuccess(result));
    } catch (e) {
      emit(AddressSavetoCartFailure(e.toString()));
    }
  }
}
