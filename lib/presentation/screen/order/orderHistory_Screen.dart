import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:eato/presentation/cubit/cart/clearCart/clearCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_state.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_cubit.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final Map<String, bool> _itemInCartStatus = {};
  final Map<String, int> _itemQuantities = {};

  @override
  void initState() {
    super.initState();
    context.read<OrderHistoryCubit>().fetchCart();
  }

  List<Map<String, dynamic>> _createPayload(OrderItem item, int quantity) => [
        {"productId": item.productId, "quantity": quantity, "price": item.price}
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(title: "Order History", showBackButton: false),
      body: BlocListener<ProductsAddToCartCubit, ProductsAddToCartState>(
        listener: (context, state) {
          if (state is ProductsAddToCartFailure || state is ProductsAddToCartRejected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state is ProductsAddToCartFailure ? 'Error: ${state.message}' : (state as ProductsAddToCartRejected).message),
                backgroundColor: state is ProductsAddToCartFailure ? Colors.red : Colors.blue,
              ),
            );
          }
        },
        child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) return const Center(child: CircularProgressIndicator());
            if (state is OrderHistoryError) return const Center(child: Text("Failed to load orders"));
            if (state is OrderHistoryLoaded) return _buildOrderList(context, state.orders);
            return const Center(child: Text('No orders found'));
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, OrderHistoryModel model) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: model.data?.content?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = model.data?.content?[index];
                if (order == null) return const SizedBox.shrink();
                return _buildOrderItem(order, context);
              },
            ),
          ),
        ],
      );

  Widget _buildSearchBar() => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for restaurants and orders',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      );

  Widget _buildOrderItem(Content order, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.PrimaryColor.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    image: order.orderItems.isNotEmpty && order.orderItems[0].media != null
                        ? DecorationImage(image: NetworkImage(order.orderItems[0].media!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: order.orderItems.isEmpty || order.orderItems[0].media == null
                      ? Icon(Icons.restaurant, color: Colors.grey[400], size: 24)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.businessName ?? 'Restaurant', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE, MMM d • h:mm a').format(order.createdDate ?? DateTime.now()),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.orderStatus ?? '').withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.orderStatus ?? 'Status',
                    style: TextStyle(
                      color: _getStatusColor(order.orderStatus ?? ''),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your order:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                const SizedBox(height: 8),
                ...order.orderItems.map((item) {
                  final itemKey = '${item.productId}_${item.productName}';
                  _itemInCartStatus.putIfAbsent(itemKey, () => false);
                  _itemQuantities.putIfAbsent(itemKey, () => item.quantity ?? 1);
                  final isInCart = _itemInCartStatus[itemKey] ?? false;
                  final quantity = _itemQuantities[itemKey] ?? 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: AppColor.PrimaryColor, shape: BoxShape.circle)),
                            Expanded(child: Text('${item.productName} (${item.quantity} items)', style: const TextStyle(fontSize: 14))),
                            if (isInCart)
                              ...[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        _itemQuantities[itemKey] = quantity - 1;
                                        _updateItemInCart(item, quantity - 1);
                                      } else {
                                        _itemInCartStatus[itemKey] = false;
                                        _removeItemFromCart(item);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(color: AppColor.PrimaryColor, shape: BoxShape.circle),
                                    child: const Icon(Icons.remove, size: 12, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('$quantity', style: const TextStyle(fontSize: 14)),
                                ),
                              ],
                            GestureDetector(
                              onTap: () async {
                                if (isInCart) {
                                  final newQuantity = quantity + 1;
                                  setState(() => _itemQuantities[itemKey] = newQuantity);
                                  _updateItemInCart(item, newQuantity);
                                } else {
                                  setState(() => _itemInCartStatus[itemKey] = true);
                                  _addItemToCart(item);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: AppColor.PrimaryColor, shape: BoxShape.circle),
                                child: Icon(isInCart ? Icons.add : Icons.add_shopping_cart, size: 12, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                        Text('₹${item.price?.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'placed':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  void _addItemToCart(OrderItem item) async {
    final cartCubit = context.read<ProductsAddToCartCubit>();
    final itemKey = '${item.productId}_${item.productName}';
    final quantity = _itemQuantities[itemKey] ?? 0;
    if (cartCubit.state is ProductsAddToCartSuccess && (cartCubit.state as ProductsAddToCartSuccess).cartModel.isNotEmpty) {
      final shouldClearCart = await _showClearCartConfirmation(context);
      if (!shouldClearCart) {
        setState(() {
          _itemQuantities[itemKey] = 0;
          _itemInCartStatus[itemKey] = false;
        });
        return;
      }
      try {
        context.read<ClearCartCubit>().clearCart();
        if (cartCubit.state is ProductsAddToCartSuccess && (cartCubit.state as ProductsAddToCartSuccess).cartModel.isEmpty) {
          await _addNewItemToCart(item, quantity, itemKey);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear cart. Please try again.'), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing cart: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } else {
      await _addNewItemToCart(item, quantity, itemKey);
    }
  }

  Future<void> _addNewItemToCart(OrderItem item, int quantity, String itemKey) async {
    try {
      await context.read<ProductsAddToCartCubit>().addToCart(_createPayload(item, quantity), context: context);
      setState(() => _itemInCartStatus[itemKey] = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${item.productName} to cart'), duration: const Duration(seconds: 1)),
      );
    } catch (e) {
      if (e is ProductsAddToCartRejected) {
        setState(() => _itemInCartStatus[itemKey] = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.blue),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add item to cart'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<bool> _showClearCartConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear Cart?'),
            content: const Text('Your cart contains items from another restaurant. Would you like to clear the cart and add these items instead?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
            ],
          ),
        ) ??
        false;
  }

  void _updateItemInCart(OrderItem item, int newQuantity) async {
    final itemKey = '${item.productId}_${item.productName}';
    final previousQuantity = _itemQuantities[itemKey] ?? 1;
    try {
      await context.read<ProductsAddToCartCubit>().addToCart(_createPayload(item, newQuantity), context: context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated ${item.productName} quantity to $newQuantity'), duration: const Duration(seconds: 1)),
      );
    } catch (e) {
      if (e is ProductsAddToCartRejected) setState(() => _itemQuantities[itemKey] = previousQuantity);
    }
  }

  void _removeItemFromCart(OrderItem item) {
    final itemKey = '${item.productId}_${item.productName}';
    context.read<ProductsAddToCartCubit>().addToCart(_createPayload(item, 0), context: context).then((_) {
      setState(() => _itemInCartStatus[itemKey] = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed ${item.productName} from cart'), duration: const Duration(seconds: 1)),
      );
    }).catchError((error) {
      if (error is ProductsAddToCartRejected) setState(() => _itemInCartStatus[itemKey] = true);
    });
  }
}
