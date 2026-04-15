import 'package:flutter/material.dart';
import '../core/app_theme.dart';


class AuthLayout extends StatelessWidget {
  final Widget child;
  final Widget? pinnedBottom;

  const AuthLayout({
    super.key,
    required this.child,
    this.pinnedBottom,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    final illustrationHeight = screenHeight * 0.12;
    final cardOverlap = 20.0;
    final topSectionHeight = screenHeight * 0.42;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // ✅ IMPORTANT

      body: Stack(
        children: [

          /// 🔥 TOP SECTION
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topSectionHeight,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: topPadding),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.015),
                    Image.asset('assets/images/logo.png',
                        height: screenHeight * 0.055),
                    SizedBox(height: screenHeight * 0.018),
                    const Text(
                      "Welcome to Self-i",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B1E1E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Login or sign up with your mobile number\nor email ID.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: illustrationHeight,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/bg.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Image.asset(
                              'assets/images/character.png',
                              height: illustrationHeight * 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: cardOverlap),
                  ],
                ),
              ),
            ),
          ),

          /// 🔥 BOTTOM CARD (FIXED)
          Positioned(
            top: topSectionHeight - cardOverlap,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.cardRadius),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade100, width: 1.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),

              child: Column(
                children: [

                  /// 🔥 SCROLL AREA
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        AppDimensions.horizontalPadding,
                        24,
                        AppDimensions.horizontalPadding,
                        MediaQuery.of(context).viewInsets.bottom + 20, // ✅ KEY FIX
                      ),
                      child: child,
                    ),
                  ),

                  /// 🔥 BOTTOM TERMS (SAFE)
                  if (pinnedBottom != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppDimensions.horizontalPadding,
                        0,
                        AppDimensions.horizontalPadding,
                        MediaQuery.of(context).viewInsets.bottom + 16,
                      ),
                      child: pinnedBottom!,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}