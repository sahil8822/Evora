import 'package:cached_network_image/cached_network_image.dart';
import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/screens/auth/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const String route = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  double _currentPage = 0.0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Plan Your Dream\nEvent Today',
      description:
          'From grand weddings to intimate parties, find everything you need to make it memorable.',
      image:
          'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=1000',
      color: AppColors.primaryColor,
    ),
    OnboardingData(
      title: 'Discover Elite\nService Vendors',
      description:
          'Browse through verified decorators, caterers, and photographers in your area.',
      image:
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=1000',
      color: const Color(0xFF6C63FF), // Complementary violet
    ),
    OnboardingData(
      title: 'Book & Manage\nWith Ease',
      description:
          'Secure your dates, track bookings, and chat with vendors all in one place.',
      image:
          'https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&q=80&w=1000',
      color: AppColors.accentColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dynamic Background Gradient
          _buildAnimatedBackground(),

          // Main Content
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _OnboardingItem(
                data: _onboardingData[index],
                index: index,
                currentPage: _currentPage,
              );
            },
          ),

          // Bottom Controls
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button with Fade
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: (_currentPage >= _onboardingData.length - 0.9)
                      ? 0.0
                      : 1.0,
                  child: TextButton(
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 0.9) {
                        context.go(LoginScreen.route);
                      }
                    },
                    child: Text(
                      'Skip',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor.withOpacity(0.6),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                // Indicators
                Row(
                  children: List.generate(
                    _onboardingData.length,
                    (index) => _buildIndicator(index),
                  ),
                ),

                // Tween Animated Progress Button
                _buildProgressButton(),
              ],
            ),
          ),

          // Header Label
          Positioned(
            top: 60,
            left: 30,
            child: Text(
              'FESTIVA',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _onboardingData[_currentPage.round()].color.withOpacity(0.12),
            Colors.white,
            Colors.white,
            _onboardingData[_currentPage.round()].color.withOpacity(0.08),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    double selectedness = (1.0 - (_currentPage - index).abs()).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 4,
      width: 8 + (16 * selectedness),
      decoration: BoxDecoration(
        color: Color.lerp(
          AppColors.primaryColor.withOpacity(0.1),
          AppColors.primaryColor,
          selectedness,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildProgressButton() {
    double progress = (_currentPage + 1) / _onboardingData.length;
    bool isLastPage = _currentPage >= _onboardingData.length - 1.1;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 74,
              height: 74,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 4,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!isLastPage) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutQuart,
                  );
                } else {
                  context.go(LoginScreen.route);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isLastPage
                      ? Icons.done_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  final OnboardingData data;
  final int index;
  final double currentPage;

  const _OnboardingItem({
    required this.data,
    required this.index,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    double relativePosition = index - currentPage;

    // Parallax Calculations
    double opacity = (1.0 - relativePosition.abs() * 1.5).clamp(0.0, 1.0);
    double scale = 0.85 + (0.15 * opacity);
    double yOffset = relativePosition * 100;
    double rotation = relativePosition * 0.2;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Decorative Shape Background
        Positioned(
          top: 150,
          child: Opacity(
            opacity: opacity * 0.5,
            child: Transform.scale(
              scale: scale * 1.2,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: data.color.withOpacity(0.1),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Modern Layered Image Presentation
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // Perspective
                  ..translate(0.0, yOffset, 0.0)
                  ..rotateY(rotation)
                  ..scale(scale),
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main Image Card
                    Container(
                      height: 420,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        boxShadow: [
                          BoxShadow(
                            color: data.color.withOpacity(0.15),
                            blurRadius: 50,
                            offset: const Offset(0, 25),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: CachedNetworkImage(
                          imageUrl: data.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          memCacheHeight: 1200,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade100,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: data.color,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.broken_image_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Image failed to load',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Floating Badge Detail
                    Positioned(
                      bottom: -20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          index == 0
                              ? Icons.celebration_rounded
                              : index == 1
                              ? Icons.auto_awesome_rounded
                              : Icons.verified_user_rounded,
                          color: data.color,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Text Content with Enhanced Typography
              Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - opacity)),
                  child: Column(
                    children: [
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.05,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}
