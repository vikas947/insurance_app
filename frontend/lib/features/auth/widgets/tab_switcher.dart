import 'package:flutter/material.dart';

class TabSwitcher extends StatelessWidget {
  final bool isMobile;
  final Function(bool) onChange;

  const TabSwitcher({
    super.key,
    required this.isMobile,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tab("Mobile Number", isMobile, () => onChange(true)),
        _tab("Email Address", !isMobile, () => onChange(false)),
      ],
    );
  }

  Widget _tab(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    active ? const Color(0xFF7A1F1F) : const Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              color: active ? const Color(0xFF7A1F1F) : const Color(0xFFE0E0E0),
            ),
          ],
        ),
      ),
    );
  }
}
