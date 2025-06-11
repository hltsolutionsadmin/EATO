import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_state.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_cubit.dart';
import 'package:eato/presentation/cubit/orders/orderHistory/orderHistory_state.dart';
import 'package:eato/presentation/screen/widgets/order_history/order_history_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final Map<String, bool> _itemInCartStatus = {};
  final Map<String, int> _itemQuantities = {};
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _pageSize = 10; // Adjust as needed
  String _searchQuery = '';
  bool _isLoadingMore = false;
  List<Content> _orders = [];
  int? bussinessId = 0;


  @override
  void initState() {
    super.initState();
    _fetchInitialOrders();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchInitialOrders() {
    _currentPage = 0;
    _orders.clear();
    context.read<OrderHistoryCubit>().fetchCart(_currentPage, _pageSize, _searchQuery);
  }

  void _fetchMoreOrders() {
    if (!_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      _currentPage++;
      context.read<OrderHistoryCubit>().fetchCart(_currentPage, _pageSize, _searchQuery);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchMoreOrders();
    }
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _fetchInitialOrders();
    context.read<OrderHistoryCubit>().fetchCart();
    cartId();
  }

  void cartId() async {
    final state = context.read<GetCartCubit>().state;
    if (state is GetCartLoaded) {
      bussinessId = state.cart.businessId;
    } else {
      bussinessId = 0;
    }
    print(bussinessId);
  }

  List<Map<String, dynamic>> _createPayload(OrderItem item, int quantity) => [
    {"productId": item.productId, "quantity": quantity, "price": item.price}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(title: "Order History", showBackButton: false),
      body: BlocListener<ProductsAddToCartCubit, dynamic>(
        listener: (context, state) {
          if (state is ProductsAddToCartFailure ||
              state is ProductsAddToCartRejected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state is ProductsAddToCartFailure
                    ? 'Error: ${state.message}'
                    : (state as ProductsAddToCartRejected).message),
                backgroundColor: state is ProductsAddToCartFailure
                    ? Colors.red
                    : Colors.blue,
              ),
            );
          }
        },
        child: BlocConsumer<OrderHistoryCubit, OrderHistoryState>(
          listener: (context, state) {
            if (state is OrderHistoryLoaded) {
              if (_currentPage == 0) {
                _orders = state.orders.data?.content ?? [];
              } else {
                _orders.addAll(state.orders.data?.content ?? []);
              }
              _isLoadingMore = false;
            }
          },
          builder: (context, state) {
            if (state is OrderHistoryLoading && _currentPage == 0) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderHistoryError) {
              return Center(child: Text("Failed to load orders: ${state.message}"));
            }
            return _buildOrderList(context);
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _buildSearchBar(),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchInitialOrders();
          },
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _orders.length + (_isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= _orders.length) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ));
              }
              final order = _orders[index];
              return _buildOrderItem(order, context);
            },
          ),
        ),
      ),
    ],
  );

  Widget _buildSearchBar() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for restaurants and orders',
          prefixIcon: GestureDetector(
            onTap: () {
              final searchText = _searchController.text;
              if (searchText.isNotEmpty) {
                _onSearchChanged(searchText);
              }
            },
            child: const Icon(Icons.search, color: Colors.grey),
          ),
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
                  final itemKey = '${item.productId}_${item.productName }';
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
                            if(item.productName == null || item.productName!.isEmpty)
                              const Expanded(child: Text('N/A', style: TextStyle(fontSize: 14)))
                            else
                            Expanded(child: Text('${item.productName ?? ''} (${item.quantity} items)', style: const TextStyle(fontSize: 14))),
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

      await context
          .read<ProductsAddToCartCubit>()
          .addToCart(payload, context: context);

      setState(() {
        _itemInCartStatus[itemKey] = true;
        _itemQuantities[itemKey] = quantity;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${item.productName} to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (e is ProductsAddToCartRejected) {
        setState(() => _itemInCartStatus[itemKey] = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.blue),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item to cart'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateItemInCart(OrderItem item, int newQuantity) async {
    final itemKey = '${item.productId}_${item.productName}';
    final previousQuantity = _itemQuantities[itemKey] ?? 1;
    try {
      await context
          .read<ProductsAddToCartCubit>()
          .addToCart(_createPayload(item, newQuantity), context: context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Updated ${item.productName} quantity to $newQuantity'),
            duration: const Duration(seconds: 1)),
      );
    } catch (e) {
      if (e is ProductsAddToCartRejected) {
        setState(() => _itemQuantities[itemKey] = previousQuantity);
      }
    }
  }

  void _removeItemFromCart(OrderItem item) {
    final itemKey = '${item.productId}_${item.productName}';
    context
        .read<ProductsAddToCartCubit>()
        .addToCart(_createPayload(item, 0), context: context)
        .then((_) {
      setState(() => _itemInCartStatus[itemKey] = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Removed ${item.productName} from cart'),
            duration: const Duration(seconds: 1)),
      );
    }).catchError((error) {
      if (error is ProductsAddToCartRejected) {
        setState(() => _itemInCartStatus[itemKey] = true);
      }
    });
  }
}