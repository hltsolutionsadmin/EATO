import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/components/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CategoryItemScreen extends StatefulWidget {
  final String categoryName;
  String searchText;

  final List<Map<String, dynamic>> items;

   CategoryItemScreen({
    super.key,
    required this.categoryName,
    this.searchText = "",
    required this.items,
  });

  @override
  _CategoryItemScreenState createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, int> cart = {};
  int totalItems = 0;
  PersistentBottomSheetController? _bottomSheetController;
  bool isBottomSheetVisible = false;

  void updateCart(String itemName, int qty) {
    setState(() {
      if (qty == 0) {
        cart.remove(itemName);
      } else {
        cart[itemName] = qty;
      }
      totalItems = cart.values.fold(0, (sum, qty) => sum + qty);
    });

    if (totalItems > 0 && !isBottomSheetVisible) {
      showPersistentCart();
    } else if (totalItems == 0 && isBottomSheetVisible) {
      _bottomSheetController?.close();
    } else if (isBottomSheetVisible) {
      _bottomSheetController?.setState!(() {});
    }
  }

  void showPersistentCart() {
    _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
      (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.PrimaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$totalItems item${totalItems > 1 ? 's' : ''} in cart",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      // Here you can handle "View Cart" tap
                      _bottomSheetController?.close();
                    },
                    child: Text(
                      "View Cart",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );

    _bottomSheetController!.closed.then((_) {
      setState(() {
        isBottomSheetVisible = false;
      });
    });

    setState(() {
      isBottomSheetVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: widget.categoryName,
        onBackPressed: (){
           Navigator.pop(context);
            if (isBottomSheetVisible) {
              _bottomSheetController?.close();
            }
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.PrimaryColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: widget.items.isEmpty
    ? Center(
        child: Text(
          "No items available",
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      )
    : Column(
        children: [
          CategorySearchBar(
            hintText: widget.categoryName,
            onChanged: (value) {
              setState(() {
                widget.searchText = value.toLowerCase();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];

                // Filtering by search text
                if (widget.searchText.isNotEmpty &&
                    !item["name"].toString().toLowerCase().contains(widget.searchText)) {
                  return const SizedBox.shrink();
                }

                final quantity = cart[item["name"]] ?? 0;

                return _CategoryItemWidget(
                  item: item,
                  quantity: quantity,
                  onQuantityChanged: (qty) => updateCart(item["name"], qty),
                );
              },
            ),
          ),
        ],
      ),


    ),
    );

  }
}

class _CategoryItemWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final int quantity;
  final Function(int) onQuantityChanged;

  const _CategoryItemWidget({
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  __CategoryItemWidgetState createState() => __CategoryItemWidgetState();
}

class __CategoryItemWidgetState extends State<_CategoryItemWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void updateQuantity(int newQty) {
    setState(() {
      quantity = newQty;
    });
    widget.onQuantityChanged(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: AppColor.PrimaryColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item["name"] ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.White,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.item["price"] ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.White,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item["description"] ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      widget.item["itemImage"] ?? '',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, size: 40),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: quantity == 0
                          ? TextButton(
                              onPressed: () => updateQuantity(1),
                              child: Text(
                                "ADD",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.White,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  color: AppColor.White,
                                  onPressed: () {
                                    if (quantity > 1) {
                                      updateQuantity(quantity - 1);
                                    } else {
                                      updateQuantity(0);
                                    }
                                  },
                                ),
                                Text(
                                  "$quantity",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.White,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  color: AppColor.White,
                                  onPressed: () => updateQuantity(quantity + 1),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
