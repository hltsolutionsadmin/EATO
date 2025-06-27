import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_cubit.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMoreItems = true;
  List<Content> _allOrders = [];
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchInitialOrders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _fetchInitialOrders() {
    _currentPage = 0;
    _hasMoreItems = true;
    _allOrders.clear();
    context
        .read<OrderHistoryCubit>()
        .fetchCart(_currentPage, _pageSize, _currentSearchQuery, context);
  }

  void _fetchMoreOrders() {
    if (!_isLoadingMore && _hasMoreItems) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      context
          .read<OrderHistoryCubit>()
          .fetchCart(_currentPage, _pageSize, _currentSearchQuery, context);
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _fetchMoreOrders();
    }
  }

  void _onSearchChanged(String query) {
    _currentSearchQuery = query;
    _fetchInitialOrders();
  }

  String timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    return '${diff.inMinutes} mins ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Orders",
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: AppColor.White,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search restaurant...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<OrderHistoryCubit, OrderHistoryState>(
              listener: (context, state) {
                if (state is OrderHistoryLoaded) {
                  final newOrders = state.orders.data?.content ?? [];
                  _hasMoreItems = newOrders.length >= _pageSize;

                  if (_currentPage == 0) {
                    _allOrders = newOrders;
                  } else {
                    _allOrders.addAll(newOrders);
                  }

                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              },
              builder: (context, state) {
                if (state is OrderHistoryLoading && _currentPage == 0) {
                  return Center(
                      child: CupertinoActivityIndicator(
                    color: AppColor.PrimaryColor,
                  ));
                } else if (state is OrderHistoryError && _currentPage == 0) {
                  return Center(child: Text("Error loading orders."));
                }

                final filteredOrders = _allOrders.where((order) {
                  final query = _currentSearchQuery.toLowerCase();
                  return order.businessName?.toLowerCase().contains(query) ??
                      false;
                }).toList();

                if (filteredOrders.isEmpty) {
                  return Center(child: Text("No orders found."));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredOrders.length + (_isLoadingMore ? 1 : 0),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    if (index >= filteredOrders.length) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }

                    final order = filteredOrders[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.PrimaryColor),
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor.White,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildOrderCard(order),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderCard(Content order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.White,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  dish,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 60),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.businessName ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Order ID: ${order.orderNumber}"),
                    Text(
                        "Time: ${timeAgo(order.createdDate ?? DateTime.now())}"),
                  ],
                ),
              ),
              Text("₹${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.PrimaryColor)),
            ],
          ),
          SizedBox(height: 12),
          Text("Status: ${order.orderStatus}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getStatusColor(order.orderStatus ?? ''),
              )),
          SizedBox(height: 12),
          order.orderStatus == 'REJECTED'
              ? SizedBox()
              : buildTracker(order.orderStatus ?? ''),
        ],
      ),
    );
  }

 Widget buildTracker(String status) {
  final steps = ["Placed", "Preparing", "On the Way", "Delivered"];
  final icons = [
    Icons.shopping_cart,
    Icons.kitchen,
    Icons.delivery_dining,
    Icons.check_circle,
  ];

  final progress = getProgressIndex(status);

  return Column(
    children: [
      Row(
        children: List.generate(steps.length, (i) {
          final isActive = i < progress;
          final isCurrent = i == progress - 1;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i != 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < progress
                              ? AppColor.PrimaryColor
                              : Colors.grey.shade300,
                        ),
                      ),

                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppColor.PrimaryColor
                                : Colors.grey.shade300,
                          ),
                          child: Icon(
                            icons[i],
                            size: 16,
                            color: isActive
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          steps[i],
                          style: TextStyle(
                            fontSize: 11,
                            color: isActive ? Colors.black87 : Colors.grey,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),

                    if (i != steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < progress - 1
                              ? AppColor.PrimaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    ],
  );
}


  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'preparing':
        return Colors.orange;
      case 'out for delivery':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  int getProgressIndex(String status) {
    switch (status.toUpperCase()) {
      case 'PLACED':
        return 1;
      case 'CONFIRMED':
      case 'ACCEPTED':
        return 2;
      case 'OUT_FOR_DELIVERY':
        return 3;
      case 'DELIVERED':
        return 4;
      default:
        return 0;
    }
  }
}
