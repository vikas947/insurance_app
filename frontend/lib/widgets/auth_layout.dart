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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardVisible = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 TOP SECTION (AUTO SHRINK)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              constraints: BoxConstraints(
                minHeight: keyboardVisible ? 0 : 120,
                maxHeight: keyboardVisible ? 120 : screenHeight * 0.34,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: keyboardVisible ? 8 : 20),
                    Image.asset(
                      'assets/images/logo.png',
                      height: keyboardVisible ? 30 : 40,
                    ),
                    SizedBox(height: keyboardVisible ? 10 : 20),
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
                    const Text(
                      "Login or sign up with your mobile number\nor email ID.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),
                    if (!keyboardVisible) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: screenHeight * 0.11,
                        child: Image.asset(
                          'assets/images/character.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ],
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
                        padding: const EdgeInsets.fromLTRB(
                          AppDimensions.horizontalPadding,
                          24,
                          AppDimensions.horizontalPadding,
                          20,
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
                          keyboardHeight + 16,
                        ),
                        child: pinnedBottom!,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
