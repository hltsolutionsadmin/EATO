import 'package:eato/domain/usecase/address/getAddress/getAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/getAddress/getAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAddressCubit extends Cubit<GetAddressState> {
  final GetAddressUseCase getAddressUseCase;

  GetAddressCubit( this.getAddressUseCase) : super(GetAddressInitial());

  Future<void> fetchAddress() async {
    emit(GetAddressLoading());
    try {
      final result = await getAddressUseCase();
      emit(GetAddressSuccess(result));
    } catch (e) {
      emit(GetAddressFailure(e.toString()));
    }
  }
}
