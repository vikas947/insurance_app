import 'package:flutter/material.dart';
import '../../../core/Theme/app_dimensions.dart';

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
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          /// TOP
          Expanded(
            flex: 4,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png", height: 50),
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome to Self-i",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1E1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Login or sign up with your mobile number\nor email ID.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Image.asset("assets/images/bg.png", height: 80),
                ],
              ),
            ),
          ),

          /// BOTTOM CARD
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.padding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: child,
                    ),
                  ),
                  if (pinnedBottom != null) pinnedBottom!,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
