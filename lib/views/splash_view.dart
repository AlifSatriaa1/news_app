import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_app/routes/app_pages.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  // Use a final variable for the primary color for clarity
  final Color primaryColor = Colors.deepPurple; // Assuming AppColors.primary maps to a deep purple

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation; // Changed to slide for a dynamic effect

  @override
  void initState() {
    super.initState();

    // Change 1: Set the system UI to match the splash screen color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: primaryColor,
    ));

    _animationController = AnimationController(
      // Change 2: Shorter, snappier duration for modern feel
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.8, curve: Curves.easeOut), // Fade slower
      ),
    );

    // Change 3: Slide animation for the icon/text coming from below
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastLinearToSlowEaseIn, // A pleasant, springy curve
      ),
    );

    _animationController.forward();

    // Navigate to home after 2.5 seconds (reduced duration for modern apps)
    Future.delayed(Duration(milliseconds: 2500), () {
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Restore default system UI style when navigating away (optional but good practice)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the resolved color variable
      backgroundColor: primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              // Change 4: Use SlideTransition instead of ScaleTransition for a different effect
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Change 5: Simplified and cleaner icon container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16), // Slightly less aggressive corner radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.newspaper_sharp, // Use a sharp version for a modern look
                        size: 55,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'GLOBAL NEWS', // Capitalized for a punchier brand name
                      style: TextStyle(
                        fontSize: 34, // Slightly larger
                        fontWeight: FontWeight.w900, // Very bold
                        color: Colors.white,
                        letterSpacing: 2, // Increased spacing for 'brand' effect
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Daily Update', // Simplified tagline
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 50),
                    // Change 6: Added some padding and adjusted progress indicator style
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3, // Thinner stroke for elegance
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}