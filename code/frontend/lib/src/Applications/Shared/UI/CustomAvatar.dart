import 'package:flutter/material.dart';
import 'package:frontend/src/theme/app_colors.dart';

/// Avatar personnalisé avec différentes tailles et styles
class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showBorder;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? badge;
  final Widget? child;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth,
    this.badge,
    this.child,
  });

  /// Avatar petit (32px)
  factory CustomAvatar.small({
    Key? key,
    String? imageUrl,
    String? initials,
    Color? backgroundColor,
    Color? textColor,
    Widget? badge,
  }) {
    return CustomAvatar(
      key: key,
      imageUrl: imageUrl,
      initials: initials,
      size: 32,
      backgroundColor: backgroundColor,
      textColor: textColor,
      badge: badge,
    );
  }

  /// Avatar moyen (40px) - par défaut
  factory CustomAvatar.medium({
    Key? key,
    String? imageUrl,
    String? initials,
    Color? backgroundColor,
    Color? textColor,
    Widget? badge,
  }) {
    return CustomAvatar(
      key: key,
      imageUrl: imageUrl,
      initials: initials,
      size: 40,
      backgroundColor: backgroundColor,
      textColor: textColor,
      badge: badge,
    );
  }

  /// Avatar grand (64px)
  factory CustomAvatar.large({
    Key? key,
    String? imageUrl,
    String? initials,
    Color? backgroundColor,
    Color? textColor,
    Widget? badge,
  }) {
    return CustomAvatar(
      key: key,
      imageUrl: imageUrl,
      initials: initials,
      size: 64,
      backgroundColor: backgroundColor,
      textColor: textColor,
      badge: badge,
    );
  }

  /// Avatar très grand (96px)
  factory CustomAvatar.xlarge({
    Key? key,
    String? imageUrl,
    String? initials,
    Color? backgroundColor,
    Color? textColor,
    Widget? badge,
  }) {
    return CustomAvatar(
      key: key,
      imageUrl: imageUrl,
      initials: initials,
      size: 96,
      backgroundColor: backgroundColor,
      textColor: textColor,
      badge: badge,
    );
  }

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    if (initials == null || initials!.isEmpty) {
      return AppColors.blueLight;
    }

    // Générer une couleur basée sur les initiales
    final hash = initials!.codeUnits.fold(0, (prev, curr) => prev + curr);
    final colors = [
      AppColors.blueLight,
      AppColors.success,
      AppColors.warning,
      AppColors.pinkDark,
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];

    return colors[hash % colors.length];
  }

  String _getInitials() {
    if (initials != null) return initials!;
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarContent = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor ?? Colors.white,
                width: borderWidth ?? 2,
              )
            : null,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: child ??
          (imageUrl == null
              ? Center(
                  child: Text(
                    _getInitials(),
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null),
    );

    if (badge != null) {
      avatarContent = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarContent,
          Positioned(
            right: 0,
            bottom: 0,
            child: badge!,
          ),
        ],
      );
    }

    return avatarContent;
  }
}

/// Badge pour avatar
class AvatarBadge extends StatelessWidget {
  final Color color;
  final double size;
  final Widget? child;
  final bool showBorder;

  const AvatarBadge({
    super.key,
    required this.color,
    this.size = 12,
    this.child,
    this.showBorder = true,
  });

  /// Badge en ligne (couleur verte)
  factory AvatarBadge.online({
    Key? key,
    double size = 12,
  }) {
    return AvatarBadge(
      key: key,
      color: AppColors.success,
      size: size,
    );
  }

  /// Badge hors ligne (couleur grise)
  factory AvatarBadge.offline({
    Key? key,
    double size = 12,
  }) {
    return AvatarBadge(
      key: key,
      color: AppColors.pinkDark,
      size: size,
    );
  }

  /// Badge occupé (couleur rouge)
  factory AvatarBadge.busy({
    Key? key,
    double size = 12,
  }) {
    return AvatarBadge(
      key: key,
      color: AppColors.error,
      size: size,
    );
  }

  /// Badge absent (couleur jaune)
  factory AvatarBadge.away({
    Key? key,
    double size = 12,
  }) {
    return AvatarBadge(
      key: key,
      color: AppColors.warning,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: showBorder ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: child,
    );
  }
}
