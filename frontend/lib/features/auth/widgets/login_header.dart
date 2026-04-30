import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo.png", height: 50),
          const SizedBox(height: 16),
          const Text(
            "Welcome to Self-i",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7B1E1E),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Login or sign up with your mobile number\nor email ID.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B6B6B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/bg.png",
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Positioned(
                  left: -10,
                  bottom: -5,
                  child: Image.asset(
                    "assets/images/character.png",
                    height: 110,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
