import 'package:flutter/material.dart';
import 'package:news_app/utils/app.colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.9),
                  AppColors.primary.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.grey.shade100,
                  Colors.grey.shade200,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        splashColor: AppColors.primary.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Colors.white,
                        key: const ValueKey('icon_selected'),
                      )
                    : const SizedBox(key: ValueKey('icon_none')),
              ),
              if (isSelected) const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: 0.3,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
