import 'package:evora/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});
  static const String route = '/payment-history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildTransactionCard(index),
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.h,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
        title: Text(
          'Payment History',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
    );
  }

  Widget _buildTransactionCard(int index) {
    final List<Map<String, dynamic>> transactions = [
      {
        'vendor': 'Sunrise Catering',
        'date': 'Oct 24, 2023',
        'amount': '₹45,000',
        'status': 'Successful',
        'type': 'Wedding Event',
      },
      {
        'vendor': 'Elite Tent House',
        'date': 'Oct 12, 2023',
        'amount': '₹12,500',
        'status': 'Successful',
        'type': 'Birthday Party',
      },
      {
        'vendor': 'Lumina Productions',
        'date': 'Sept 15, 2023',
        'amount': '₹8,000',
        'status': 'Successful',
        'type': 'Pre-wedding Shoot',
      },
      {
        'vendor': 'Gourmet World',
        'date': 'Aug 28, 2023',
        'amount': '₹22,000',
        'status': 'Successful',
        'type': 'Anniversary',
      },
      {
        'vendor': 'Spark Photographers',
        'date': 'Aug 10, 2023',
        'amount': '₹15,000',
        'status': 'Refunded',
        'type': 'Outdoor Shoot',
      },
      {
        'vendor': 'Majestic Palms',
        'date': 'July 24, 2023',
        'amount': '₹95,000',
        'status': 'Successful',
        'type': 'Corporate Gala',
      },
    ];

    final transaction = transactions[index % transactions.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['vendor'],
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${transaction['type']} • ${transaction['date']}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction['amount'],
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                transaction['status'],
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: transaction['status'] == 'Successful'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
