import 'package:flutter/material.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const PhoneInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey)),
            ),
            child: const Row(
              children: [
                Text("🇮🇳"),
                SizedBox(width: 6),
                Text("+91"),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Mobile Number",
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
