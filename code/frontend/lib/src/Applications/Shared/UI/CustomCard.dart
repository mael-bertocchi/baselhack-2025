import 'package:flutter/material.dart';

/// Carte personnalisée réutilisable avec différents styles
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.width,
    this.height,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
    this.border,
  });

  /// Card avec style élevé (shadow importante)
  factory CustomCard.elevated({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return CustomCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(16),
      backgroundColor: backgroundColor ?? Colors.white,
      width: width,
      height: height,
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      child: child,
    );
  }

  /// Card avec style subtle (shadow légère)
  factory CustomCard.subtle({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return CustomCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(16),
      backgroundColor: backgroundColor ?? Colors.white,
      width: width,
      height: height,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      child: child,
    );
  }

  /// Card avec bordure au lieu d'ombre
  factory CustomCard.outlined({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? borderColor,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return CustomCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(16),
      backgroundColor: backgroundColor ?? Colors.white,
      width: width,
      height: height,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor ?? const Color(0xFFE5E7EB),
        width: 1,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: boxShadow,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius as BorderRadius? ?? BorderRadius.circular(12),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
