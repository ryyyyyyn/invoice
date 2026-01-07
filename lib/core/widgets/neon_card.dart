import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double padding;
  final Color? backgroundColor;
  final bool glowing;

  const NeonCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = 16,
    this.backgroundColor,
    this.glowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: glowing
            ? [
                BoxShadow(
                  color: AppColors.accentNeon.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
