import 'package:evora_partner_app/components/custom_text_field.dart';
import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:evora_partner_app/screens/auth/authentication/forgot_password_screen.dart';
import 'package:evora_partner_app/screens/auth/authentication/signup_screen.dart';
import 'package:evora_partner_app/screens/home/screens/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEmailLogin = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Text(
                "Welcome Back",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: 8.h),
              Text(
                "Login to manage your business",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 40.h),

              // Login Toggle
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFF2F4F7)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildToggleButton(
                        "Email",
                        _isEmailLogin,
                        () => setState(() => _isEmailLogin = true),
                      ),
                    ),
                    Expanded(
                      child: _buildToggleButton(
                        "Phone",
                        !_isEmailLogin,
                        () => setState(() => _isEmailLogin = false),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              if (_isEmailLogin) ...[
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email address",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.secondaryColor,
                      size: 20.sp,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ] else ...[
                CustomTextField(
                  controller: _phoneController,
                  hintText: "Phone number",
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                ),
              ],

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(ForgotPasswordScreen.route),
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              ElevatedButton(
                onPressed: () => context.go(HomeScreens.route),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56.h),
                ),
                child: Text(_isEmailLogin ? "Sign In" : "Send OTP"),
              ),

              SizedBox(height: 32.h),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Or continue with",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 24.h),

              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.g_mobiledata_rounded,
                  size: 28.sp,
                  color: AppColors.googleColor,
                ),
                label: const Text("Continue with Google"),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56.h),
                ),
              ),

              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.push(SignupScreen.route),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
