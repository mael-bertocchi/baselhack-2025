import 'package:flutter/material.dart';

/// Badge personnalisé pour afficher des notifications, statuts, etc.
class CustomBadge extends StatelessWidget {
  final String? label;
  final int? count;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;
  final Widget? child;
  final BadgePosition position;
  final bool showZero;

  const CustomBadge({
    super.key,
    this.label,
    this.count,
    this.backgroundColor,
    this.textColor,
    this.size,
    this.child,
    this.position = BadgePosition.topRight,
    this.showZero = false,
  });

  /// Badge de notification (rouge)
  factory CustomBadge.notification({
    Key? key,
    int? count,
    Widget? child,
    BadgePosition position = BadgePosition.topRight,
    bool showZero = false,
  }) {
    return CustomBadge(
      key: key,
      count: count,
      backgroundColor: const Color(0xFFEF4444),
      textColor: Colors.white,
      child: child,
      position: position,
      showZero: showZero,
    );
  }

  /// Badge de succès (vert)
  factory CustomBadge.success({
    Key? key,
    String? label,
    int? count,
    Widget? child,
    BadgePosition position = BadgePosition.topRight,
  }) {
    return CustomBadge(
      key: key,
      label: label,
      count: count,
      backgroundColor: const Color(0xFF10B981),
      textColor: Colors.white,
      child: child,
      position: position,
    );
  }

  /// Badge d'avertissement (jaune)
  factory CustomBadge.warning({
    Key? key,
    String? label,
    int? count,
    Widget? child,
    BadgePosition position = BadgePosition.topRight,
  }) {
    return CustomBadge(
      key: key,
      label: label,
      count: count,
      backgroundColor: const Color(0xFFF59E0B),
      textColor: Colors.white,
      child: child,
      position: position,
    );
  }

  /// Badge primaire
  factory CustomBadge.primary({
    Key? key,
    String? label,
    int? count,
    Widget? child,
    BadgePosition position = BadgePosition.topRight,
  }) {
    return CustomBadge(
      key: key,
      label: label,
      count: count,
      backgroundColor: const Color(0xFF14B8A6),
      textColor: Colors.white,
      child: child,
      position: position,
    );
  }

  /// Badge dot (simple point)
  factory CustomBadge.dot({
    Key? key,
    Color? backgroundColor,
    Widget? child,
    BadgePosition position = BadgePosition.topRight,
  }) {
    return CustomBadge(
      key: key,
      backgroundColor: backgroundColor ?? const Color(0xFFEF4444),
      size: 8,
      child: child,
      position: position,
    );
  }

  String _getDisplayText() {
    if (label != null) return label!;
    if (count != null) {
      if (count! > 99) return '99+';
      if (count! == 0 && !showZero) return '';
      return count.toString();
    }
    return '';
  }

  Widget _buildBadge() {
    final displayText = _getDisplayText();
    final isDot = size != null && size! < 12;

    if (displayText.isEmpty && !isDot) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: isDot
          ? null
          : EdgeInsets.symmetric(
              horizontal: displayText.length == 1 ? 6 : 8,
              vertical: 2,
            ),
      constraints: isDot
          ? BoxConstraints.tight(Size(size!, size!))
          : BoxConstraints(
              minWidth: size ?? 20,
              minHeight: size ?? 20,
            ),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(isDot ? size! / 2 : 10),
        border: Border.all(
          color: Colors.white,
          width: isDot ? 1.5 : 2,
        ),
      ),
      child: isDot
          ? null
          : Center(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: displayText.length > 2 ? 10 : 12,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return _buildBadge();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: position.isTop ? -4 : null,
          bottom: position.isBottom ? -4 : null,
          left: position.isLeft ? -4 : null,
          right: position.isRight ? -4 : null,
          child: _buildBadge(),
        ),
      ],
    );
  }
}

/// Position du badge
enum BadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

extension BadgePositionExtension on BadgePosition {
  bool get isTop => this == BadgePosition.topRight || this == BadgePosition.topLeft;
  bool get isBottom => this == BadgePosition.bottomRight || this == BadgePosition.bottomLeft;
  bool get isLeft => this == BadgePosition.topLeft || this == BadgePosition.bottomLeft;
  bool get isRight => this == BadgePosition.topRight || this == BadgePosition.bottomRight;
}
