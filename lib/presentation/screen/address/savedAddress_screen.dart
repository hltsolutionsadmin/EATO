import 'package:eato/core/constants/colors.dart';
import 'package:eato/data/model/address/getAddress/getAddress_model.dart';
import 'package:eato/presentation/cubit/address/defaultAddress/get/getDefaultAddress_cubit.dart';
import 'package:eato/presentation/cubit/address/defaultAddress/post/defaultAddress_cubit.dart';
import 'package:eato/presentation/cubit/address/deleteAddress/deleteAddress_cubit.dart';
import 'package:eato/presentation/cubit/address/getAddress/getAddress_cubit.dart';
import 'package:eato/presentation/cubit/address/getAddress/getAddress_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedAddressesView extends StatelessWidget {
  final Function(Content)? onAddressSelected;

  const SavedAddressesView({super.key, this.onAddressSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAddressCubit, GetAddressState>(
      builder: (context, state) {
        if (state is GetAddressLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is GetAddressSuccess) {
          final addresses = state.addressModel.data?.content ?? [];
          return _buildAddressList(context, addresses);
        }
        
        if (state is GetAddressFailure) {
          return _buildErrorView(context, state);
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAddressList(BuildContext context, List<Content> addresses) {
    // Sort addresses - default address first
    final sortedAddresses = List<Content>.from(addresses)
      ..sort((a, b) {
        if (a.isDefault == true && b.isDefault != true) return -1;
        if (a.isDefault != true && b.isDefault == true) return 1;
        return 0;
      });

    if (sortedAddresses.isEmpty) {
      return _buildEmptyView(context);
    }
    
    return RefreshIndicator(
      onRefresh: () async => context.read<GetAddressCubit>().fetchAddress(context),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedAddresses.length,
        itemBuilder: (context, index) => _buildAddressCard(
          context, 
          sortedAddresses[index],
          isDefault: sortedAddresses[index].isDefault ?? false,
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text("No saved addresses yet",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => DefaultTabController.of(context).animateTo(0),
            child: Text("Add New Address",
                style: TextStyle(color: AppColor.PrimaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, GetAddressFailure state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text("Failed to load addresses",
              style: TextStyle(fontSize: 16, color: Colors.red.shade700)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<GetAddressCubit>().fetchAddress(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.PrimaryColor),
            child: const Text("Retry",style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Content address, {bool isDefault = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDefault 
            ? AppColor.PrimaryColor 
            : Colors.grey.shade200, 
          width: isDefault ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (onAddressSelected != null) {
            onAddressSelected!(address);
          } else {
            final addressId = address.id!;
            final addressString = '${address.addressLine1}, ${address.city}';
            context.read<DefaultAddressCubit>().setDefaultAddress(addressId, context);
            context.read<AddressSavetoCartCubit>().addressSavetoCart(addressId, context);
            Navigator.pop(context,addressString);
          }
        },

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColor.PrimaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isDefault ? "Default Address" : "Saved Address",
                    style: TextStyle(
                      color: isDefault 
                        ? AppColor.PrimaryColor 
                        : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.check_circle, 
                      color: AppColor.PrimaryColor, 
                      size: 18
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Address details with better spacing
              if (address.addressLine1?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(address.addressLine1!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),

              if (address.addressLine2?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(address.addressLine2!,
                      style: TextStyle(color: Colors.grey.shade600)),
                ),

              if (address.street?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(address.street!,
                      style: TextStyle(color: Colors.grey.shade600)),
                ),

              Text('${address.city}, ${address.state} - ${address.postalCode}',
                  style: TextStyle(color: Colors.grey.shade600)),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  OutlinedButton.icon(
                    icon: Icon(Icons.delete, size: 18, color: Colors.red),
                    label: const Text("DELETE",
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.red.withOpacity(0.5)),
                    ),
                    onPressed: () =>
                        _showDeleteConfirmation(context, address.id!),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editAddress(BuildContext context, Content address) {
    DefaultTabController.of(context).animateTo(0);
  }

  void _showDeleteConfirmation(BuildContext context, int addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DeleteAddressCubit>().deleteAddress(addressId, context);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}