import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double? height;

  const StatusBadge({
    super.key,
    required this.status,
    this.height,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'draft':
        return AppColors.textSecondary;
      case 'sent':
        return AppColors.statusInfo;
      case 'partial_paid':
      case 'partial paid':
        return AppColors.statusWarning;
      case 'paid':
        return AppColors.statusSuccess;
      case 'overdue':
        return AppColors.statusError;
      case 'cancelled':
        return AppColors.textTertiary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getDisplayLabel() {
    switch (status.toLowerCase()) {
      case 'partial_paid':
        return 'Partial Paid';
      default:
        return status[0].toUpperCase() + status.substring(1).replaceAll('_', ' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Container(
      height: height ?? 28,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Center(
        child: Text(
          _getDisplayLabel(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
