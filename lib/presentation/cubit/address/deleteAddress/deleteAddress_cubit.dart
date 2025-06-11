import 'package:eato/domain/usecase/address/deleteAddress/deleteAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/deleteAddress/deleteAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAddressCubit extends Cubit<DeleteAddressState> {
  final DeleteAddressUseCase usecase;

  DeleteAddressCubit(this.usecase) : super(DeleteAddressInitial());

  Future<void> deleteAddress(int addressId) async {
    emit(DeleteAddressLoading());
    try {
      final result = await usecase.execute(addressId);
      emit(DeleteAddressSuccess(result));
    } catch (e) {
      emit(DeleteAddressFailure(e.toString()));
    }
  }
}
