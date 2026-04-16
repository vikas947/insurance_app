import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class TabSwitcher extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final Function(int) onTabChanged;

  const TabSwitcher({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final isActive = currentIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? AppColors.secondary : AppColors.lightGrey,
                    width: isActive ? 2.5 : 1,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 15,
                    color: isActive ? AppColors.secondary : AppColors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
