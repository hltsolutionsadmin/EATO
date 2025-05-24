import 'package:eato/components/custom_button.dart' as eato_button;
import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_state.dart';
import 'package:eato/presentation/screen/dashboard/address_scren.dart';
import 'package:eato/presentation/screen/widgets/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(bool) onBottomSheetVisibilityChanged;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onBottomSheetVisibilityChanged,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<String, int> cart;
  late List<Map<String, dynamic>> selectedItems;

  static const double gstPercentage = 0.05;
  static const double deliveryCharge = 30.0;

  String selectedAddress = "123 Main Street, City, ZipCode";

  @override
  void initState() {
    super.initState();
    _initializeCartAndSelectedItems();
  }

  void _initializeCartAndSelectedItems() {
    cart = {};
    selectedItems = [];
    for (var item in widget.cartItems) {
      final productId = item['productId'] as int?;
      final quantity = item['quantity'] as int?;
      final name = item['name'] as String?;
      if (productId != null && quantity != null && quantity > 0 && name != null) {
        cart[name] = quantity;
        selectedItems.add(item);
      }
    }
  }

  void updateCartItemQuantity(String itemName, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        removeCartItem(itemName);
      } else {
        cart[itemName] = newQuantity;
        if (!selectedItems.any((item) => item['name'] == itemName)) {
          final foundItem = widget.cartItems.firstWhere(
            (item) => item['name'] == itemName,
            orElse: () => {},
          );
          if (foundItem.isNotEmpty) {
            selectedItems.add(foundItem);
          }
        }
      }
    });
    widget.onBottomSheetVisibilityChanged(cart.isNotEmpty);
  }

  void removeCartItem(String itemName) {
    setState(() {
      cart.remove(itemName);
      selectedItems.removeWhere((item) => item['name'] == itemName);
    });
    widget.onBottomSheetVisibilityChanged(cart.isNotEmpty);
  }

  double getSubtotal() {
    return selectedItems.fold(0.0, (subtotal, item) {
      final name = item['name'] as String?;
      final price = item['price'];
      final quantity = cart[name] ?? 0;

      if (name == null || quantity == 0) return subtotal;

      double itemPrice = price is String
          ? double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0
          : price is double
              ? price
              : 0.0;

      return subtotal + (itemPrice * quantity);
    });
  }

  int getCartItemCount() => cart.values.fold(0, (sum, qty) => sum + qty);
  double getGSTAmount() => getSubtotal() * gstPercentage;
  double getTotalAmount() => getSubtotal() + getGSTAmount() + deliveryCharge;

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    final textStyle = TextStyle(
      fontSize: isBold ? 18 : 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text("₹${amount.toStringAsFixed(2)}", style: textStyle),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> getCartPayload() {
    return selectedItems.map((item) {
      final name = item['name'] as String?;
      final quantity = cart[name] ?? 0;
      final price = item['price'];

      return {
        'productId': item['productId'],
        'quantity': quantity,
        'price': price,
      };
    }).toList();
  }

  void handleCheckout(BuildContext context) {
    final payload = getCartPayload();
    context.read<ProductsAddToCartCubit>().addToCart(payload);
    print("Payload: $payload");
  }

  

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsAddToCartCubit, ProductsAddToCartState>(
      listener: (context, state) {
        if (state is ProductsAddToCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checkout successful!')),
          );
          Navigator.pop(context);
        } else if (state is ProductsAddToCartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "Cart (${getCartItemCount()} items)",
            onBackPressed: () {
              final updatedCart = <String, int>{};
              for (var item in selectedItems) {
                final name = item['name'] as String?;
                if (name != null && cart.containsKey(name)) {
                  updatedCart[name] = cart[name]!;
                }
              }
              Navigator.pop(context, {
                'updatedCart': updatedCart,
                'cartItemsLength': getCartItemCount(),
              });
              widget.onBottomSheetVisibilityChanged(updatedCart.isNotEmpty);
            },
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.PrimaryColor, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Deliver to", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text(
                                selectedAddress,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddressScreen()),
                            );
                          },
                          child: const Text("Edit"),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: selectedItems.isEmpty
                        ? const Center(
                            child: Text(
                              "No items in the cart!",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 180),
                            itemCount: selectedItems.length,
                            itemBuilder: (context, index) {
                              final item = selectedItems[index];
                              final quantity = cart[item['name']] ?? 0;
                              return CartItemWidget(
                                item: item,
                                quantity: quantity,
                                onQuantityChanged: updateCartItemQuantity,
                                onRemove: removeCartItem,
                              );
                            },
                          ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, -2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPriceRow("Subtotal", getSubtotal()),
                      _buildPriceRow("GST (5%)", getGSTAmount()),
                      _buildPriceRow("Delivery Charge", deliveryCharge),
                      const Divider(thickness: 1),
                      _buildPriceRow("Total", getTotalAmount(), isBold: true),
                      const SizedBox(height: 12),
                      state is ProductsAddToCartLoading
                          ? const CircularProgressIndicator()
                          : eato_button.CustomButton(
                              buttonText: "Checkout",
                              onPressed: () => handleCheckout(context),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
