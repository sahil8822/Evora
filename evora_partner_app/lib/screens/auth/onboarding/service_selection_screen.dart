import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:evora_partner_app/screens/auth/onboarding/vendor_profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});
  static const String route = '/service-selection';

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  final List<Map<String, dynamic>> _services = [
    {'name': 'Tent House', 'icon': Icons.house_rounded},
    {'name': 'Decoration & Lighting', 'icon': Icons.lightbulb_rounded},
    {'name': 'Wedding Garden', 'icon': Icons.landscape_rounded},
    {'name': 'Catering', 'icon': Icons.restaurant_rounded},
    {'name': 'DJ', 'icon': Icons.music_note_rounded},
    {'name': 'Cameraman', 'icon': Icons.camera_alt_rounded},
    {'name': 'Mehendi', 'icon': Icons.brush_rounded},
    {'name': 'Wedding Card Printing', 'icon': Icons.mail_rounded},
    {'name': 'Corporate Events', 'icon': Icons.business_center_rounded},
  ];

  final Set<int> _selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text("Select Services")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(24.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.1,
              ),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndices.contains(index);
                final service = _services[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIndices.remove(index);
                      } else {
                        _selectedIndices.add(index);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : const Color(0xFFF2F4F7),
                        width: 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          service['icon'],
                          size: 32.sp,
                          color: isSelected
                              ? Colors.white
                              : AppColors.primaryColor,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          service['name'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: ElevatedButton(
              onPressed: _selectedIndices.isEmpty
                  ? null
                  : () => context.push(VendorProfileSetupScreen.route),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56.h),
              ),
              child: Text("Continue with ${_selectedIndices.length} items"),
            ),
          ),
        ],
      ),
    );
  }
}
