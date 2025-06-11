import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/network_helper.dart';
import '../../../../../core/network/network_service.dart';
import '../../../../../domain/usecase/authentication/current_customer_usecase.dart';
import 'current_customer_state.dart';

class CurrentCustomerCubit extends Cubit<CurrentCustomerState> {
  final CurrentCustomerValidationUseCase currentCustomerValidationUseCase;
  final NetworkService networkService;

  CurrentCustomerCubit(
      this.currentCustomerValidationUseCase, this.networkService)
      : super(CurrentCustomerInitial());

  void startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        emit(CurrentCustomerInitial());
      }
    });
  }
   void reset() {
    emit(CurrentCustomerInitial());
  }

  Future<void> GetCurrentCustomer(BuildContext context) async {
    bool isConnected = await NetworkHelper.checkInternetAndShowSnackbar(
      context: context,
      networkService: networkService,
    );
    if (!isConnected) return;

    try {
      emit(CurrentCustomerLoading());
      final currentCustomerModel = await currentCustomerValidationUseCase();
      if (!isClosed) {
        emit(CurrentCustomerLoaded(currentCustomerModel));
      }
    } catch (e) {
      if (!isClosed) {
debugPrint('Error loading customer: $e');
        emit(CurrentCustomerError(
            'Failed to fetch current customer data: ${e.toString()}'));
      }
    }
  }
}
