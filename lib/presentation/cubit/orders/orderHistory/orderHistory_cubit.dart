import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/orders/orderHistory/orderHistory_usecase.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final OrderHistoryUseCase useCase;
  final NetworkService networkService;

  OrderHistoryCubit(this.useCase, this.networkService)
      : super(OrderHistoryInitial());

  Future<void> fetchCart(
      int page, int size, String searchQuery, context) async {
    bool isConnected = await networkService.hasInternetConnection();
    print(isConnected);
    if (!isConnected) {
      print("No Internet Connection");
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    } else {
      emit(OrderHistoryLoading());
      try {
        final cart = await useCase.execute(page, size, searchQuery);
        emit(OrderHistoryLoaded(cart));
      } catch (e) {
        print('Error fetching order history: $e');
        emit(OrderHistoryError(e.toString()));
      }
    }
  }
}
