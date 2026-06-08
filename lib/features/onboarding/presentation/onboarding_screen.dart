import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Welcome to Aura',
      description: 'Your intelligent financial companion. Experience the future of personal finance with a stunning glassmorphic interface.',
      icon: Icons.auto_awesome,
      color: AppColors.gold,
    ),
    _OnboardingPageData(
      title: 'Smart Categorization',
      description: 'Aura uses AI to automatically categorize your transactions and clean up messy bank statements.',
      icon: Icons.psychology,
      color: AppColors.emerald,
    ),
    _OnboardingPageData(
      title: 'Predictive Insights',
      description: 'Stay ahead of your bills. Aura predicts upcoming subscriptions and tracks your budgets in real-time.',
      icon: Icons.insights,
      color: AppColors.blue,
    ),
  ];

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    widget.onComplete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      body: Stack(
        children: [
          // Background ambient shapes
          Positioned(
            top: -100,
            left: -50,
            child: _buildAmbientOrb(AppColors.emerald.withValues(alpha: 0.15), 300),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildAmbientOrb(AppColors.blue.withValues(alpha: 0.15), 250),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: MediaQuery.of(context).size.width * 0.3,
            child: _buildAmbientOrb(AppColors.ruby.withValues(alpha: 0.1), 200),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 50,
          )
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPageData page) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glass icon container
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppColors.glassBorder),
                  boxShadow: [
                    BoxShadow(
                      color: page.color.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Center(
                  child: Icon(
                    page.icon,
                    size: 80,
                    color: page.color,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            page.title,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 60),
      child: Column(
        children: [
          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.gold
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Buttons
          Row(
            children: [
              if (_currentPage < _pages.length - 1)
                TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                const SizedBox(width: 60), // Match Skip button width for balance
              
              const Spacer(),
              
              ElevatedButton(
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    );
                  } else {
                    _completeOnboarding();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  shadowColor: AppColors.gold.withValues(alpha: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _currentPage < _pages.length - 1
                          ? Icons.arrow_forward
                          : Icons.rocket_launch,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
