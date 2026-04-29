import 'package:flutter/material.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "By signing up, you agree to the ",
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF666666),
        ),
        children: const [
          TextSpan(
            text: "Terms of Service",
            style: TextStyle(
              color: Color(0xFF0A3D91),
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Data Processing Agreement",
            style: TextStyle(
              color: Color(0xFF0A3D91),
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
