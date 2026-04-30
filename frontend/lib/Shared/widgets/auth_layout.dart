import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          /// 🔴 HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// LOGO
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),

                const SizedBox(height: 24),

                /// TITLE
                const Text(
                  "Welcome to Self-i",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1E1E),
                  ),
                ),

                const SizedBox(height: 12),

                /// SUBTITLE
                const Text(
                  "Login or sign up with your mobile number\nor email ID.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 30),

                /// ILLUSTRATION
                SizedBox(
                  height: 110,
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
                        left: -10,
                        bottom: -5,
                        child: Image.asset(
                          'assets/images/character.png',
                          height: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔴 CARD
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: child,
                    ),
                  ),
                  if (pinnedBottom != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
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
