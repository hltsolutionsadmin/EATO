import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTracker extends StatelessWidget {
  final String orderId;
  final String status;

  const OrderTracker({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Tracking',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(),
              const SizedBox(height: 32),
              _buildStatusCard(),
              const SizedBox(height: 32),
              _buildTimeline(),
              const SizedBox(height: 32),
              _buildDeliveryInfo(),
              const SizedBox(height: 32),
              _buildHelpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #$orderId',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track Your Order',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'preparing':
        statusText = 'Preparing Your Order';
        statusColor = AppColor.PrimaryColor;
        statusIcon = Icons.restaurant;
        break;
      case 'onway':
        statusText = 'On The Way';
        statusColor = Colors.blue;
        statusIcon = Icons.delivery_dining;
        break;
      case 'delivered':
        statusText = 'Delivered';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusText = 'Order Received';
        statusColor = Colors.grey;
        statusIcon = Icons.shopping_bag;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 16,
        //     offset: const Offset(0, 8),
        // ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusSubtitle(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusSubtitle() {
    switch (status) {
      case 'preparing':
        return 'Your food is being prepared with care';
      case 'onway':
        return 'Your delivery is on its way';
      case 'delivered':
        return 'Enjoy your meal!';
      default:
        return 'We\'ve received your order';
    }
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineTile(
            'Order Confirmed',
            true,
            icon: Icons.check_circle,
            isFirst: true,
          ),
          _buildTimelineTile(
            'Preparing',
            status != 'placed',
            icon: Icons.restaurant,
          ),
          _buildTimelineTile(
            'On The Way',
            status == 'onway' || status == 'delivered',
            icon: Icons.delivery_dining,
          ),
          _buildTimelineTile(
            'Delivered',
            status == 'delivered',
            icon: Icons.flag,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile(
    String text,
    bool isCompleted, {
    IconData? icon,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.2,
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isCompleted ? AppColor.PrimaryColor : Colors.grey[200]!,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        width: 32,
        height: 32,
        indicator: Container(
          decoration: BoxDecoration(
            color: isCompleted ? AppColor.PrimaryColor : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? AppColor.PrimaryColor : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 16, color: Colors.white)
                : Icon(icon, size: 16, color: Colors.grey),
          ),
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                color: isCompleted ? Colors.black : Colors.grey[600],
              ),
            ),
            if (isCompleted && !isLast)
              Text(
                _getTimelineSubtitle(text),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getTimelineSubtitle(String status) {
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    switch (status) {
      case 'Order Confirmed':
        return 'Confirmed at $time';
      case 'Preparing':
        return 'Started at $time';
      case 'On The Way':
        return 'Dispatched at $time';
      case 'Delivered':
        return 'Delivered at $time';
      default:
        return '';
    }
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on, 'Delivery Address',
              '123 Main Street, City, Country'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.access_time, 'Estimated Delivery Time',
              status == 'delivered' ? 'Delivered' : '30-45 minutes'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor.PrimaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColor.PrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColor.PrimaryColor),
          ),
          elevation: 0,
        ),
        child: const Text('Need Help? Contact Support'),
      ),
    );
  }
}
