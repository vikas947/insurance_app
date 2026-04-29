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

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          /// 🔝 TOP SECTION (AUTO SHRINK)
          Flexible(
            fit: FlexFit.loose,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 🔥 MUST
                  children: [
                    const SizedBox(height: 30),

                    /// Logo
                    Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                    ),

                    const SizedBox(height: 20),

                    /// Title
                    const Text(
                      "Welcome to Self-i",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B1E1E),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Subtitle
                    const Text(
                      "Login or sign up with your mobile number\nor email ID.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Illustration (NO OVERFLOW)
                    SizedBox(
                      height: screenHeight * 0.08,
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
                            left: -12,
                            bottom: -4,
                            child: Image.asset(
                              'assets/images/character.png',
                              height: screenHeight * 0.11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 🔽 BOTTOM CARD
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.cardRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 40,
                    offset: const Offset(0, -12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// 🔥 SCROLLABLE FORM
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        AppDimensions.horizontalPadding,
                        24,
                        AppDimensions.horizontalPadding,
                        MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: child,
                    ),
                  ),

                  /// 🔽 TERMS (STICKY)
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
