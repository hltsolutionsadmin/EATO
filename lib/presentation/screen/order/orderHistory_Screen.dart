import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_cubit.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderHistoryCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
        builder: (context, state) {
          if (state is OrderHistoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderHistoryError) {
            return Center(child: Text(state.message));
          } else if (state is OrderHistoryLoaded) {
            return _buildOrderList(context, state.model);
          }
          return Center(child: Text('No orders found'));
        },
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, OrderHistoryModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildSearchBar(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: _buildFilterChips(),
          ),
          SizedBox(height: 16),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: model.data.length,
            separatorBuilder: (_, __) => SizedBox(height: 20),
            itemBuilder: (context, index) {
              return _buildOrderItem(model.data[index], context);
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(title: 'Order History',showBackButton: false,);
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search orders...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'This Month', 'Delivered', 'Cancelled'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: filter == 'All',
              onSelected: (_) {},
              backgroundColor: Colors.white,
              selectedColor: AppColor.PrimaryColor,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: filter == 'All' ? Colors.white : Colors.black87,
              ),
              shape: StadiumBorder(
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderItem(Datum order, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.SecondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // You might want to replace this with actual restaurant image from your API
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              dish, // Using a placeholder image
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.restaurantName ?? 'Restaurant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            _getStatusColor(order.orderStatus ?? '').withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.orderStatus ?? 'Status',
                        style: TextStyle(
                          color: _getStatusColor(order.orderStatus ?? ''),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      order.createdDate != null 
                          ? DateFormat('MMM dd, yyyy').format(order.createdDate!)
                          : 'Date not available',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Spacer(),
                    Text(
                      '${order.orderItems.length} ${order.orderItems.length > 1 ? 'items' : 'item'}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    // You can add rating if available in your API response
                    _buildRatingStars(4), // Placeholder rating
                    Spacer(),
                    Text(
                      '\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.repeat, size: 20, color: Colors.black),
                        label: Text(
                          'Reorder',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () => _reorder(order),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.description,
                            size: 20, color: Colors.white),
                        label: Text(
                          'Details',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _viewOrderDetails(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.PrimaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: Colors.amber,
            size: 20,
          );
        }),
        SizedBox(width: 4),
        Text(
          rating.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  void _viewOrderDetails(Datum order) {
    print('View details for order ${order.orderNumber}');
  }

  void _reorder(Datum order) {
    print('Reorder ${order.orderNumber}');
  }
}