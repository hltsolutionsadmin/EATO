import 'package:eato/domain/usecase/address/saveAddress/saveAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/saveAddress/saveAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveAddressCubit extends Cubit<SaveAddressState> {
  final SaveAddressUseCase useCase;

  SaveAddressCubit(this.useCase) : super(SaveAddressInitial());

  Future<void> saveAddress(Map<String, dynamic> payload) async {
    emit(SaveAddressLoading());

    try {
      final result = await useCase.call(payload);
      emit(SaveAddressSuccess(result));
    } catch (e) {
      emit(SaveAddressFailure(e.toString()));
    }
  }
}
