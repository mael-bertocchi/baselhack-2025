import 'package:flutter/material.dart';
import 'package:frontend/src/theme/AppColors.dart';

/// Chip personnalisé pour les tags et badges
class CustomChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const CustomChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.leadingIcon,
    this.trailingIcon,
    this.onTap,
    this.onDelete,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  /// Chip primaire
  factory CustomChip.primary({
    Key? key,
    required String label,
    Widget? leadingIcon,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return CustomChip(
      key: key,
      label: label,
      backgroundColor: AppColors.blueLight.withOpacity(0.1),
      textColor: AppColors.blueLight,
      leadingIcon: leadingIcon,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  /// Chip succès
  factory CustomChip.success({
    Key? key,
    required String label,
    Widget? leadingIcon,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return CustomChip(
      key: key,
      label: label,
      backgroundColor: AppColors.success.withOpacity(0.1),
      textColor: AppColors.success,
      leadingIcon: leadingIcon,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  /// Chip avertissement
  factory CustomChip.warning({
    Key? key,
    required String label,
    Widget? leadingIcon,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return CustomChip(
      key: key,
      label: label,
      backgroundColor: AppColors.warning.withOpacity(0.1),
      textColor: AppColors.warning,
      leadingIcon: leadingIcon,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  /// Chip erreur
  factory CustomChip.error({
    Key? key,
    required String label,
    Widget? leadingIcon,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return CustomChip(
      key: key,
      label: label,
      backgroundColor: AppColors.error.withOpacity(0.1),
      textColor: AppColors.error,
      leadingIcon: leadingIcon,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  /// Chip neutre
  factory CustomChip.neutral({
    Key? key,
    required String label,
    Widget? leadingIcon,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return CustomChip(
      key: key,
      label: label,
      backgroundColor: AppColors.pinkBackground,
      textColor: AppColors.textSecondary,
      leadingIcon: leadingIcon,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  /// Chip outlined
  factory CustomChip.outlined({
    Key? key,
    required String label,
    Widget? leadingIcon,
    VoidCallback? onTap,
    VoidCallback? onDelete,
    Color? borderColor,
  }) {
    return CustomChip(
      key: key,
      label: label,
      backgroundColor: Colors.transparent,
      textColor: borderColor ?? AppColors.textPrimary,
      borderColor: borderColor ?? AppColors.pinkDark,
      leadingIcon: leadingIcon,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius as BorderRadius? ?? BorderRadius.circular(16),
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.pinkDark,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor ?? AppColors.textPrimary,
                  fontSize: fontSize ?? 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 4),
                trailingIcon!,
              ],
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(10),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: textColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
