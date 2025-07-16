import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_cubit.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'rating_service.dart';

class GlobalRatingListener extends StatefulWidget {
  final Widget child;
  const GlobalRatingListener({super.key, required this.child});

  @override
  State<GlobalRatingListener> createState() => _GlobalRatingListenerState();
}

class _GlobalRatingListenerState extends State<GlobalRatingListener> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRatingCheckTimer();
  }

  void _startRatingCheckTimer() {
    _timer = Timer.periodic(Duration(minutes: 2), (_) => _checkOrders());
  }

  void _checkOrders() {
    final cubit = context.read<OrderHistoryCubit>();
    cubit.fetchCart(0, 20, '', context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderHistoryCubit, OrderHistoryState>(
      listener: (context, state) {
        if (state is OrderHistoryLoaded) {
          final orders = state.orders.data?.content ?? [];
          RatingService().checkAndShowRatingPopup(
            context: context,
            orders: orders,
          );
        }
      },
      child: widget.child,
    );
  }
}
