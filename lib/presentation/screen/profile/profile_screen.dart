import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:eato/presentation/screen/address/address_screen.dart';
import 'package:eato/presentation/screen/order/myOrders_screen.dart';
import 'package:eato/presentation/screen/widgets/logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

@override
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
          return Text('Error fetching profile');
        } else if (state is CurrentCustomerLoading) {
          return CupertinoActivityIndicator();
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
            MaterialPageRoute(
              builder: (context) => MyOrders(),
            ));
      }),
      _Option(Icons.location_on_outlined, "Saved Addresses", onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddressScreen()));
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
                color: opt.title == "Logout" ? Colors.red : Colors.black,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: opt.title == "Logout" ? Colors.red : AppColor.PrimaryColor,
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
}

class _Option {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  _Option(this.icon, this.title, {this.onTap});
}
