import 'package:evora/components/app_button.dart';
import 'package:evora/components/app_text.dart';
import 'package:evora/components/custom_text_field.dart';
import 'package:evora/components/social_button.dart';
import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/screens/auth/authentication/forgot_password_screen.dart';
import 'package:evora/screens/auth/authentication/signup_screen.dart';
import 'package:evora/screens/home/screens/home_screens.dart';
import 'package:flutter/material.dart';
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentColor.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Logo Section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Evora",
                          style: GoogleFonts.inriaSerif(
                            fontSize: 48,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const AppText(
                          text: "Login to your account",
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  const SizedBox(height: 32),

                  // Form Section
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Email Address",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
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
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(ForgotPasswordScreen.route),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: "Sign In",
                    onPressed: () {
                      context.go(HomeScreens.route);
                    },
                  ),

                  const SizedBox(height: 32),
                  // Divider Section
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.textSecondary.withOpacity(0.2),
                          thickness: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: AppText(
                          text: "Or continue with",
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.textSecondary.withOpacity(0.2),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Social Login Section
                  SocialButton(
                    icon: const Icon(
                      Icons.g_mobiledata_rounded,
                      color: AppColors.googleColor,
                      size: 32,
                    ),
                    text: "Continue with Google",
                    onPressed: () {
                      // Handle Google Login
                    },
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    icon: const Icon(
                      Icons.apple_rounded,
                      color: AppColors.appleColor,
                      size: 24,
                    ),
                    text: "Continue with Apple",
                    onPressed: () {
                      // Handle Apple Login
                    },
                  ),

                  const SizedBox(height: 40),
                  // Bottom Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppText(
                        text: "Don't have an account? ",
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      GestureDetector(
                        onTap: () => context.push(SignupScreen.route),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
