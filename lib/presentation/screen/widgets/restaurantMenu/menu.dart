import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/presentation/cubit/cart/clearCart/clearCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:flutter/material.dart';
import 'package:eato/data/model/restaurants/guestMenuByRestaurantId/menu_content_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItemWidget extends StatefulWidget {
  final Content item;
  final int quantity;
  final dynamic restaurantId;
  final String? restaurantName;
  final Function(int) onQuantityChanged;
  final bool isGuest;
  final VoidCallback? onGuestAttempt;

  const MenuItemWidget({
    super.key,
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
    required this.restaurantId,
    this.restaurantName,
    this.isGuest = false,
    this.onGuestAttempt,
  });

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void updateQuantity(int newQty) {
    setState(() => quantity = newQty);
    widget.onQuantityChanged(newQty);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final mediaUrl =
        item.media?.isNotEmpty == true ? item.media!.first.url : null;

    return BlocBuilder<GetCartCubit, GetCartState>(
      builder: (context, state) {
        final cartData = state is GetCartLoaded ? state.cart : null;
        final cartBusinessId = cartData?.businessId?.toString();

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColor.PrimaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: mediaUrl != null
                      ? Image.network(
                          mediaUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Image.asset(dish, fit: BoxFit.cover),
                        )
                      : Image.asset(dish, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? "",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹${item.price ?? '0'}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle, color: AppColor.PrimaryColor),
                    onPressed: () async {
                      if (widget.isGuest) {
                        widget.onGuestAttempt?.call();
                        return;
                      }

                      if (cartData != null &&
                          cartData.cartItems?.isNotEmpty == true &&
                          widget.restaurantId.toString() != cartBusinessId) {
                        final shouldReplace = await showReplaceCartDialog(
                          context: context,
                          currentRestaurant: cartData.businessName ?? '',
                          newRestaurant: widget.restaurantName ?? '',
                        );
                        if (shouldReplace != true) return;

                        try {
                          await context
                              .read<ClearCartCubit>()
                              .clearCart(context);
                          await context.read<GetCartCubit>().fetchCart(context);
                          updateQuantity(1);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to clear cart: ${e.toString()}')),
                          );
                        }
                      } else {
                        updateQuantity(quantity + 1);
                      }
                    },
                  ),
                  Text(
                    '$quantity',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      if (quantity > 0) {
                        updateQuantity(quantity - 1);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}


Future<bool?> showReplaceCartDialog({
  required BuildContext context,
  required String currentRestaurant,
  required String newRestaurant,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text(
        'Replace cart items?',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Your cart contains dishes from '),
            TextSpan(
              text: currentRestaurant,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const TextSpan(
                text:
                    '. Do you want to discard the selection and add dishes from '),
            TextSpan(
              text: newRestaurant,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const TextSpan(text: '?'),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColor.PrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Replace'),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
