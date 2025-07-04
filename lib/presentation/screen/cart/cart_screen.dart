import 'dart:convert';
import 'package:eato/components/custom_button.dart' as eato_button;
import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_state.dart';
import 'package:eato/presentation/cubit/payment/payment_cubit.dart';
import 'package:eato/presentation/cubit/payment/payment_state.dart';
import 'package:eato/presentation/screen/address/address_screen.dart';
import 'package:eato/presentation/screen/cart/cart_screen_helper_widget.dart';
import 'package:eato/presentation/screen/widgets/cart/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final int? orderId;
  final List<Map<String, dynamic>>? cartItems;
  final Function(bool)? onBottomSheetVisibilityChanged;
  final Widget? customCheckoutButton;
  const CartScreen({
    super.key,
    this.orderId,
    this.cartItems,
    this.onBottomSheetVisibilityChanged,
    this.customCheckoutButton,
  });
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final Razorpay _razorpay;
  static const razorPayKey = 'rzp_test_aa2AmRQV2HpRyT';
  static const razorPaySecret = 'UMfObdnXjWv3opzzTwHwAiv8';
  bool loading = false;
  final Map<String, int> cart = {};
  final List<Map<String, dynamic>> selectedItems = [];
  int? cartId;
  static const double gstPercentage = 0.05;
  static const double deliveryCharge = 30.0;
  String selectedAddress = "Add Address";

  @override
  void initState() {
    super.initState();
    context.read<GetCartCubit>().fetchCart(context);
    _loadSavedAddress();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    _initializeCartAndSelectedItems();
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final exactAmount = getTotalAmount();
      print(exactAmount);
      final payload = {
        "cartId": cartId ?? 0,
        "amount": exactAmount,
        "paymentId": response.paymentId,
        "razorpayOrderId": response.orderId,
        "razorpaySignature": response.signature,
        "status": "SUCCESS"
      };
      setState(() => loading = true);
      await context.read<PaymentCubit>().makePayment(payload, context);
      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'ERROR',
        message: 'Payment or order creation failed:: ${e.toString()}',
      );
    }
  }

  void handlePaymentFailure(PaymentFailureResponse response) {
    CustomSnackbars.showErrorSnack(
      context: context,
      title: 'ERROR',
      message: 'payment failed, please try after some time',
    );
    setState(() => loading = false);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    CustomSnackbars.showInfoSnack(
      context: context,
      title: 'Info',
      message: 'Transaction under process, please check after some time',
    );
    setState(() => loading = false);
  }

  Future<void> openCheckOut() async {
    print(selectedAddress);
    if (selectedAddress == "Add Address") {
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'ERROR',
        message: 'Please select a delivery address before proceeding',
      );
      return;
    } else {
      if (cartId == null) {
        CustomSnackbars.showErrorSnack(
          context: context,
          title: 'ERROR',
          message: 'Cart not loaded, please try again',
        );
        return;
      }
      setState(() => loading = true);
      try {
        final exactAmount = getTotalAmount();
        final amountInPaise = (exactAmount * 100).toInt();
        final orderId = await createOrder(amount: amountInPaise);
        final options = {
          'key': razorPayKey,
          'amount': amountInPaise,
          'name': 'EATO',
          'order_id': orderId,
          'description': 'Order for cart $cartId',
          'prefill': {
            'contact': '9705047662',
            'email': 'harishpeela03@gmail.com'
          },
          'theme': {
            'color': '#081724',
            'hide_topbar': false,
            'backdrop_color': '#081724',
          }
        };
        _razorpay.open(options);
      } catch (e) {
        setState(() => loading = false);
        CustomSnackbars.showErrorSnack(
          context: context,
          title: 'ERROR',
          message: 'Failed to process payment: ${e.toString()}',
        );
      }
    }
  }

  Future<Map<String, dynamic>> razorPayApi(num amount, String recieptId) async {
    final auth =
        'Basic ${base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'))}';
    final headers = {
      'content-type': 'application/json',
      "Access-Control_Allow_Origin": "*",
      'Authorization': auth
    };
    final data = {
      "amount": amount.toInt(),
      "currency": "INR",
      "receipt": recieptId
    };
    final request =
        http.Request('POST', Uri.parse('https://api.razorpay.com/v1/orders'))
          ..body = json.encode(data)
          ..headers.addAll(headers);
    final response = await request.send();
    if (response.statusCode == 200) {
      return {
        "status": "success",
        "body": jsonDecode(await response.stream.bytesToString())
      };
    } else {
      return {"status": "fail", "message": (response.reasonPhrase)};
    }
  }

  Future<String> createOrder({required num amount}) async {
    final myData = await razorPayApi(amount, "rcp_id_2");
    return myData["status"] == "success" ? myData["body"]["id"] : "";
  }

  void _initializeCartAndSelectedItems() {
    if (widget.cartItems != null) {
      for (final item in widget.cartItems!) {
        final productId = item['productId'] as int?;
        final quantity = item['quantity'] as int?;
        final name = item['name'] as String?;
        if (productId != null &&
            quantity != null &&
            quantity > 0 &&
            name != null) {
          cart[name] = quantity;
          selectedItems.add(item);
        }
      }
    }
  }

  void updateCartItemQuantity(String itemName, int newQuantity) {
    if (newQuantity <= 0) {
      removeCartItem(itemName);
    } else {
      setState(() {
        cart[itemName] = newQuantity;
        if (!selectedItems.any((item) => item['name'] == itemName)) {
          final foundItem = widget.cartItems?.firstWhere(
            (item) => item['name'] == itemName,
            orElse: () => {},
          );
          if (foundItem != null && foundItem.isNotEmpty) {
            selectedItems.add(foundItem as Map<String, dynamic>);
          }
        }
      });
    }
    widget.onBottomSheetVisibilityChanged?.call(cart.isNotEmpty);
  }

  void removeCartItem(String itemName) {
    setState(() {
      cart.remove(itemName);
      selectedItems.removeWhere((item) => item['name'] == itemName);
    });
    widget.onBottomSheetVisibilityChanged?.call(cart.isNotEmpty);
  }

  double getSubtotal() => selectedItems.fold(0.0, (subtotal, item) {
        final name = item['name'] as String?;
        final price = item['price'];
        final quantity = cart[name] ?? 0;
        if (name == null || quantity == 0) return subtotal;
        final itemPrice = price is String
            ? double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0
            : price is double
                ? price
                : 0.0;
        return subtotal + (itemPrice * quantity);
      });

  int getCartItemCount() => cart.values.fold(0, (sum, qty) => sum + qty);
  double getGSTAmount() => getSubtotal() * gstPercentage;
  double getTotalAmount() {
    final subtotal = getSubtotal();
    final gst = subtotal * gstPercentage;
    return (subtotal + gst + deliveryCharge).floorToDouble();
  }

  List<Map<String, dynamic>> getCartPayload() => selectedItems.map((item) {
        final name = item['name'] as String?;
        final quantity = cart[name] ?? 0;
        final price = item['price'];
        return {
          'productId': item['productId'],
          'quantity': quantity,
          'price': price,
        };
      }).toList();

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAddress = prefs.getString('delivery_address') ?? "Add Address";
    });
  }

  Future<void> _saveAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('delivery_address', address);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductsAddToCartCubit, ProductsAddToCartState>(
          listener: (context, state) {
            if (state is ProductsAddToCartFailure) {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Something went wrong please try after sometime')),
              );
            }
          },
        ),
        BlocListener<GetCartCubit, GetCartState>(
          listener: (context, state) {
            if (state is GetCartLoaded) {
              setState(() => cartId = state.cart.id);
            }
          },
        ),
        BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentRefundSuccess) {
              CustomSnackbars.showErrorSnack(
                context: context,
                title: 'FAILURE',
                message:
                    'Your order was not confirmed, if any amount was deducted, it will be refunded within 24 hours!',
              );
            } else if (state is PaymentSuccess) {
              CustomSnackbars.showSuccessSnack(
                context: context,
                title: 'SUCCESS',
                message: 'Payment successful, order created successfully!',
              );
            } else if (state is PaymentFailure) {
              CustomSnackbars.showErrorSnack(
                context: context,
                title: 'ERROR',
                message: state.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Cart (${getCartItemCount()} items)",
          onBackPressed: () {
            final updatedCart = <String, int>{};
            for (final item in selectedItems) {
              final name = item['name'] as String?;
              if (name != null && cart.containsKey(name)) {
                updatedCart[name] = cart[name]!;
              }
            }
            Navigator.pop(context, {
              'updatedCart': updatedCart,
              'cartItemsLength': getCartItemCount(),
            });
            widget.onBottomSheetVisibilityChanged?.call(updatedCart.isNotEmpty);
          },
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.White, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.PrimaryColor.withOpacity(0.1),
                      border: Border.all(color: AppColor.PrimaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Deliver to",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              Text(
                                selectedAddress == "Add Address"
                                    ? "Select delivery address"
                                    : selectedAddress,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: selectedAddress == "Add Address"
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final address = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddressScreen(),
                              ),
                            );
                            if (address != null) {
                              await _saveAddress(address);
                              setState(() => selectedAddress = address);
                            }
                          },
                        ),
                      ],
                    ),
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
                    BuildPriceRow("Subtotal", getSubtotal()),
                    BuildPriceRow("GST (5%)", getGSTAmount()),
                    BuildPriceRow("Delivery Charge", deliveryCharge),
                    const Divider(thickness: 1),
                    BuildPriceRow("Total", getTotalAmount(), isBold: true),
                    const SizedBox(height: 12),
                    BlocBuilder<PaymentCubit, PaymentState>(
                      builder: (context, paymentState) {
                        return BlocBuilder<ProductsAddToCartCubit,
                            ProductsAddToCartState>(
                          builder: (context, cartState) {
                            if (paymentState is PaymentLoading ||
                                cartState is ProductsAddToCartLoading) {
                              return CupertinoActivityIndicator(
                                color: AppColor.PrimaryColor,
                              );
                            }
                            return eato_button.CustomButton(
                              buttonText: "Checkout",
                              onPressed: () {
                                setState(() => loading = true);
                                openCheckOut();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
