import 'package:eato/domain/usecase/address/defaultAddress/post/defaultAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/defaultAddress/post/defaultAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DefaultAddressCubit extends Cubit<DefaultAddressState> {
  final DefaultAddressUseCase useCase;

  DefaultAddressCubit(this.useCase) : super(DefaultAddressInitial());

  Future<void> setDefaultAddress(int addressId) async {
    emit(DefaultAddressLoading());

    try {
      final result = await useCase(addressId);
      emit(DefaultAddressSuccess(defaultAddressModel: result));
    } catch (e) {
      emit(DefaultAddressFailure(error: e.toString()));
    }
  }
}
