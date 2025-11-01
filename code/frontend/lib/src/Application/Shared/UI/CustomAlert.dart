import 'package:flutter/material.dart';
import 'package:frontend/src/theme/AppColors.dart';

/// Alerte personnalisée pour afficher des messages
class CustomAlert extends StatelessWidget {
  final String? title;
  final String message;
  final AlertType type;
  final Widget? leadingIcon;
  final VoidCallback? onClose;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  final bool showIcon;

  const CustomAlert({
    super.key,
    this.title,
    required this.message,
    this.type = AlertType.info,
    this.leadingIcon,
    this.onClose,
    this.actions,
    this.padding,
    this.showIcon = true,
  });

  /// Alerte d'information
  factory CustomAlert.info({
    Key? key,
    String? title,
    required String message,
    VoidCallback? onClose,
    List<Widget>? actions,
  }) {
    return CustomAlert(
      key: key,
      title: title,
      message: message,
      type: AlertType.info,
      onClose: onClose,
      actions: actions,
    );
  }

  /// Alerte de succès
  factory CustomAlert.success({
    Key? key,
    String? title,
    required String message,
    VoidCallback? onClose,
    List<Widget>? actions,
  }) {
    return CustomAlert(
      key: key,
      title: title,
      message: message,
      type: AlertType.success,
      onClose: onClose,
      actions: actions,
    );
  }

  /// Alerte d'avertissement
  factory CustomAlert.warning({
    Key? key,
    String? title,
    required String message,
    VoidCallback? onClose,
    List<Widget>? actions,
  }) {
    return CustomAlert(
      key: key,
      title: title,
      message: message,
      type: AlertType.warning,
      onClose: onClose,
      actions: actions,
    );
  }

  /// Alerte d'erreur
  factory CustomAlert.error({
    Key? key,
    String? title,
    required String message,
    VoidCallback? onClose,
    List<Widget>? actions,
  }) {
    return CustomAlert(
      key: key,
      title: title,
      message: message,
      type: AlertType.error,
      onClose: onClose,
      actions: actions,
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case AlertType.info:
        return const Color(0xFF3B82F6).withOpacity(0.1);
      case AlertType.success:
        return const Color(0xFF10B981).withOpacity(0.1);
      case AlertType.warning:
        return const Color(0xFFF59E0B).withOpacity(0.1);
      case AlertType.error:
        return const Color(0xFFEF4444).withOpacity(0.1);
    }
  }

  Color get _borderColor {
    switch (type) {
      case AlertType.info:
        return const Color(0xFF3B82F6).withOpacity(0.3);
      case AlertType.success:
        return const Color(0xFF10B981).withOpacity(0.3);
      case AlertType.warning:
        return const Color(0xFFF59E0B).withOpacity(0.3);
      case AlertType.error:
        return const Color(0xFFEF4444).withOpacity(0.3);
    }
  }

  Color get _iconColor {
    switch (type) {
      case AlertType.info:
        return const Color(0xFF3B82F6);
      case AlertType.success:
        return const Color(0xFF10B981);
      case AlertType.warning:
        return const Color(0xFFF59E0B);
      case AlertType.error:
        return const Color(0xFFEF4444);
    }
  }

  IconData get _defaultIcon {
    switch (type) {
      case AlertType.info:
        return Icons.info_outline;
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            leadingIcon ??
                Icon(
                  _defaultIcon,
                  color: _iconColor,
                  size: 20,
                ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              if (title != null) const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: actions!,
                  ),
                ],
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(4),
              child: Icon(
                Icons.close,
                color: _iconColor,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Type d'alerte
enum AlertType {
  info,
  success,
  warning,
  error,
}
