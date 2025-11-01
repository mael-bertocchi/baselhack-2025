import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:frontend/src/theme/AppColors.dart';

/// Bouton personnalisé avec différents styles
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isLoading;
  final bool isDisabled;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fontSize,
    this.fontWeight,
  });

  /// Bouton primaire (rempli)
  factory CustomButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Widget? leadingIcon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColors.blueLight,
      textColor: Colors.white,
      width: width,
      height: height ?? 48,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  /// Bouton secondaire (outlined)
  factory CustomButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Widget? leadingIcon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      textColor: AppColors.blueLight,
      width: width,
      height: height ?? 48,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  /// Bouton ghost (texte uniquement)
  factory CustomButton.ghost({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? textColor,
    Widget? leadingIcon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      textColor: textColor ?? AppColors.textSecondary,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  /// Bouton danger
  factory CustomButton.danger({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Widget? leadingIcon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColors.error,
      textColor: Colors.white,
      width: width,
      height: height ?? 48,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isDisabled
        ? AppColors.pinkDark
        : backgroundColor ?? AppColors.blueLight;

    final effectiveTextColor = isDisabled
        ? AppColors.textTertiary
        : textColor ?? Colors.white;

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: MoonFilledButton(
        backgroundColor: effectiveBackgroundColor,
        onTap: (isDisabled || isLoading) ? null : onPressed,
        borderRadius: borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null && !isLoading) ...[
              leadingIcon!,
              const SizedBox(width: 8),
            ],
            if (isLoading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 16,
                fontWeight: fontWeight ?? FontWeight.w600,
                color: effectiveTextColor,
              ),
            ),
            if (trailingIcon != null && !isLoading) ...[
              const SizedBox(width: 8),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
