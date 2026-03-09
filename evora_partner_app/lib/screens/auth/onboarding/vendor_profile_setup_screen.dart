import 'package:evora_partner_app/components/custom_text_field.dart';
import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:evora_partner_app/screens/home/screens/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorProfileSetupScreen extends StatefulWidget {
  const VendorProfileSetupScreen({super.key});
  static const String route = '/profile-setup';

  @override
  State<VendorProfileSetupScreen> createState() =>
      _VendorProfileSetupScreenState();
}

class _VendorProfileSetupScreenState extends State<VendorProfileSetupScreen> {
  int _currentStep = 0;

  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      context.go(HomeScreens.route);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Profile Setup"),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    height: 4.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? AppColors.accentColor
                          : AppColors.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildStepContent(),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24.w),
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56.h),
              ),
              child: Text(_currentStep == 2 ? "Complete Setup" : "Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildAddressStep();
      case 2:
        return _buildMediaStep();
      default:
        return Container();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "Tell us about your business",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 24.h),
        Center(
          child: Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF2F4F7), width: 2),
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 32.sp,
                  color: AppColors.secondaryColor,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: AppColors.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, size: 14.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),
        CustomTextField(
          controller: _businessNameController,
          labelText: "Business Name",
          hintText: "e.g. Royal Tent House",
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: _ownerNameController,
          labelText: "Owner Name",
          hintText: "Full name",
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: _descriptionController,
          labelText: "Business Description",
          hintText: "Briefly describe your services...",
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "Where are you located?",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 24.h),
        CustomTextField(
          controller: _cityController,
          labelText: "City",
          hintText: "e.g. Jaipur",
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: _addressController,
          labelText: "Business Address",
          hintText: "Full office/shop address",
          maxLines: 3,
        ),
        SizedBox(height: 16.h),
        const CustomTextField(
          labelText: "Service Area",
          hintText: "e.g. Within 50km of Jaipur",
        ),
      ],
    );
  }

  Widget _buildMediaStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "Showcase your work",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8.h),
        Text(
          "Upload images of your past events and setups.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 24.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF2F4F7)),
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.secondaryColor,
                size: 24.sp,
              ),
            );
          },
        ),
      ],
    );
  }
}
