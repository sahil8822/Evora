import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorProfileScreen extends StatefulWidget {
  final String serviceName;
  const VendorProfileScreen({super.key, required this.serviceName});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final List<String> _galleryImages = [];
  final List<String> _amenities = [];
  final List<Map<String, String>> _packages = [];

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amenityController = TextEditingController();
  final TextEditingController _packageTitleController = TextEditingController();
  final TextEditingController _packagePriceController = TextEditingController();

  void _addAmenity() {
    if (_amenityController.text.isNotEmpty) {
      setState(() {
        _amenities.add(_amenityController.text);
        _amenityController.clear();
      });
    }
  }

  void _addPackage() {
    if (_packageTitleController.text.isNotEmpty &&
        _packagePriceController.text.isNotEmpty) {
      setState(() {
        _packages.add({
          'title': _packageTitleController.text,
          'price': _packagePriceController.text,
        });
        _packageTitleController.clear();
        _packagePriceController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.serviceName} Profile',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Business Information'),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    _businessNameController,
                    'Business Name',
                    Icons.business,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    _priceController,
                    'Base Price (₹)',
                    Icons.money,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionTitle('Gallery Images'),
                  SizedBox(height: 12.h),
                  Container(
                    height: 100.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _galleryImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _galleryImages.length) {
                          return GestureDetector(
                            onTap: () {
                              // Simulate image pick
                              setState(() {
                                _galleryImages.add(
                                  'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&q=80&w=400',
                                );
                              });
                            },
                            child: _buildAddIndicator(),
                          );
                        }
                        return _buildImageCard(_galleryImages[index]);
                      },
                    ),
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionTitle('Amenities'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          _amenityController,
                          'Add Amenity',
                          Icons.check_circle_outline,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        onPressed: _addAmenity,
                        icon: const Icon(Icons.add_circle),
                        color: AppColors.primaryColor,
                        iconSize: 32.sp,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.w,
                    children: _amenities
                        .map(
                          (a) => Chip(
                            label: Text(a),
                            onDeleted: () =>
                                setState(() => _amenities.remove(a)),
                            backgroundColor: Colors.white,
                            deleteIconColor: Colors.red,
                          ),
                        )
                        .toList(),
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionTitle('Booking Packages'),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    _packageTitleController,
                    'Package Title (e.g. Silver Plan)',
                    Icons.title,
                  ),
                  SizedBox(height: 8.h),
                  _buildTextField(
                    _packagePriceController,
                    'Package Price (₹)',
                    Icons.payments,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: _addPackage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      minimumSize: Size(double.infinity, 45.h),
                      shape: RoundedRectangleHeader(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text(
                      'Add Package',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ..._packages.map(
                    (p) => ListTile(
                      title: Text(p['title']!),
                      subtitle: Text('₹${p['price']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => _packages.remove(p)),
                      ),
                    ),
                  ),

                  SizedBox(height: 48.h),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile Saved Successfully!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: Size(double.infinity, 55.h),
                      shape: RoundedRectangleHeader(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'SAVE PROFILE',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAddIndicator() {
    return Container(
      width: 100.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(
        Icons.add_photo_alternate,
        color: AppColors.primaryColor,
        size: 32.sp,
      ),
    );
  }

  Widget _buildImageCard(String url) {
    return Container(
      width: 100.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

class RoundedRectangleHeader extends RoundedRectangleBorder {
  RoundedRectangleHeader({super.borderRadius});
}
