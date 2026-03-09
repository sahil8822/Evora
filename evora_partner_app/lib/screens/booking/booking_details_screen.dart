import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:evora_partner_app/screens/messages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> booking;
  const BookingDetailsScreen({super.key, required this.booking});
  static const String route = '/booking-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text("Booking Details")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.successColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppColors.successColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status: Confirmed",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        "Payment: Paid (₹5,000 Deposit)",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),
            _buildSectionTitle("Customer Information"),
            SizedBox(height: 16.h),
            _buildInfoCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: AppColors.backgroundColor,
                    child: const Icon(Icons.person),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['customerName'] ?? "Sahil Mansuri",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        Text(
                          "+91 98765 43210",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildCircleAction(Icons.call, Colors.green, () {}),
                  SizedBox(width: 12.w),
                  _buildCircleAction(Icons.message, AppColors.accentColor, () {
                    context.push(
                      ChatScreen.route,
                      extra: {
                        'name': booking['customerName'],
                        'imageUrl': 'https://i.pravatar.cc/150?u=sahil',
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 32.h),
            _buildSectionTitle("Event Information"),
            SizedBox(height: 16.h),
            _buildInfoCard(
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.calendar_month,
                    "Date",
                    booking['date'] ?? "12 Oct, 2024",
                  ),
                  _buildDetailRow(
                    Icons.location_on,
                    "Venue",
                    booking['location'] ?? "Vidhyadhar Nagar, Jaipur",
                  ),
                  _buildDetailRow(
                    Icons.group,
                    "Guests",
                    "${booking['guests'] ?? 500} People",
                  ),
                  _buildDetailRow(Icons.timer, "Time", "06:00 PM - 11:00 PM"),
                ],
              ),
            ),

            SizedBox(height: 32.h),
            _buildSectionTitle("Service Details"),
            SizedBox(height: 16.h),
            _buildInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wedding Magic Full Package",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Includes: Luxury tent setup, Lighting, Buffet decorations, Stage setup, and VIP lounge furniture.",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const Divider(),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        booking['price'] ?? "₹25,000",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 48.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56.h),
                backgroundColor: AppColors.accentColor,
              ),
              child: const Text("Update Booking Status"),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: AppColors.secondaryColor),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }
}
