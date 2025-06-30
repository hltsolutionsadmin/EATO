import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:eato/presentation/cubit/authentication/deleteAccount/deleteAccount_cubit.dart';
import 'package:eato/presentation/cubit/authentication/deleteAccount/deleteAccount_state.dart';
import 'package:eato/presentation/screen/address/address_screen.dart';
import 'package:eato/presentation/screen/order/myOrders_screen.dart';
import 'package:eato/presentation/screen/widgets/logout.dart';
import 'package:eato/presentation/screen/authentication/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool isGuest;
  const ProfileScreen({super.key, this.isGuest = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CurrentCustomerCubit>(context).GetCurrentCustomer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.White,
      appBar: CustomAppBar(title: "My Profile", showBackButton: false),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(context),
            const SizedBox(height: 24),
            _buildBasicOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return BlocBuilder<CurrentCustomerCubit, CurrentCustomerState>(
      builder: (context, state) {
        if (state is CurrentCustomerLoaded) {
          final customer = state.currentCustomerModel;
          return Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColor.PrimaryColor.withOpacity(0.1),
                child:
                    Icon(Icons.person, size: 40, color: AppColor.PrimaryColor),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.fullName ?? 'No Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.PrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.primaryContact ?? 'No Phone Number',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          );
        } else if (state is CurrentCustomerError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColor.PrimaryColor.withOpacity(0.1),
                    child:
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      state.message, // ✅ show actual error message
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<CurrentCustomerCubit>()
                      .GetCurrentCustomer(context);
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.PrimaryColor,
                ),
              ),
            ],
          );
        } else if (state is CurrentCustomerLoading) {
          return const CupertinoActivityIndicator();
        }

        return Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppColor.PrimaryColor.withOpacity(0.1),
              child: Icon(Icons.person, size: 40, color: AppColor.PrimaryColor),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.PrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBasicOptions(BuildContext context) {
    final options = [
      _Option(Icons.shopping_bag_outlined, "My Orders", onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyOrders()),
        );
      }),
      _Option(Icons.location_on_outlined, "Saved Addresses", onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddressScreen()),
        );
      }),
      _Option(Icons.logout, "Logout", onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => const LogOutCnfrmBottomSheet(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        );
      }),
      _Option(Icons.delete_forever_outlined, "Delete Account", onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true, // important
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _buildDeleteConfirmation(context),
        );
      }),
    ];

    return Column(
      children: options.map((opt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(opt.icon, color: AppColor.PrimaryColor),
            title: Text(
              opt.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: opt.title == "Logout" || opt.title == "Delete Account"
                    ? Colors.red
                    : Colors.black,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: opt.title == "Logout" || opt.title == "Delete Account"
                  ? Colors.red
                  : AppColor.PrimaryColor,
            ),
            onTap: opt.onTap ?? () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeleteConfirmation(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<DeleteAccountCubit>(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded,
                color: AppColor.PrimaryColor, size: 40),
            const SizedBox(height: 16),
            Text(
              "Are you sure?",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.PrimaryColor),
            ),
            const SizedBox(height: 12),
            const Text(
              "This will permanently delete your account and all associated data.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                    listener: (context, state) async {
                      if (state is DeleteAccountSuccess) {
                        Navigator.pop(context); // Close bottom sheet

                        CustomSnackbars.showSuccessSnack(
                          context: context,
                          title: "Deleted",
                          message: "Your account has been deleted.",
                        );

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('TOKEN');
                        prefs.clear();

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      } else if (state is DeleteAccountFailure) {
                        CustomSnackbars.showErrorSnack(
                          context: context,
                          title: "Error",
                          message: "Failed to delete account",
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.PrimaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: state is DeleteAccountLoading
                            ? null
                            : () {
                                context
                                    .read<DeleteAccountCubit>()
                                    .deleteAccount();
                              },
                        child: state is DeleteAccountLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Delete"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Option {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  _Option(this.icon, this.title, {this.onTap});
}
