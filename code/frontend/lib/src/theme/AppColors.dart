import 'package:flutter/material.dart';

/// Couleurs de l'application Consensus Hub
class AppColors {
  AppColors._();

  // ============================================================================
  // COULEURS PRIMAIRES
  // ============================================================================
  
  /// Bleu principal - #469CDD
  static const Color blue = Color(0xFF469CDD);
  
  /// Rose principal - #9A1E5B
  static const Color pink = Color(0xFF9A1E5B);

  // ============================================================================
  // ACCENTS BLEUS
  // ============================================================================
  
  /// Bleu clair
  static const Color blueLight = Color.fromARGB(255, 86, 165, 255);
  
  /// Bleu foncé
  static const Color blueDark = Color(0xFF1E40AF);
  
  /// Fond bleu (pour badges, états)
  static const Color blueBackground = Color(0xFFDCEDFF);

  // ============================================================================
  // ACCENTS ROSES
  // ============================================================================
  
  /// Rose clair
  static const Color pinkLight = Color(0xFFFCE7F3);
  
  /// Rose foncé
  static const Color pinkDark = Color(0xFF831843);
  
  /// Fond rose (pour badges, états)
  static const Color pinkBackground = Color(0xFFFDF2F8);

  // ============================================================================
  // COULEURS DE FOND
  // ============================================================================
  
  /// Fond principal - #F1F4F6
  static const Color background = Color(0xFFF1F4F6);
  
  /// Blanc pur
  static const Color white = Color(0xFFFFFFFF);

  // ============================================================================
  // COULEURS DE TEXTE
  // ============================================================================
  
  /// Texte principal - Gray 800
  static const Color textPrimary = Color(0xFF1F2937);
  
  /// Texte secondaire - Gray 500
  static const Color textSecondary = Color(0xFF6B7280);
  
  /// Texte tertiaire - Gray 400
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  /// Texte désactivé - Gray 300
  static const Color textDisabled = Color(0xFFD1D5DB);

  // ============================================================================
  // COULEURS DE STATUT
  // ============================================================================
  
  /// Succès / Vert
  static const Color success = Color(0xFF10B981);
  
  /// Avertissement / Orange
  static const Color warning = Color(0xFFF59E0B);
  
  /// Erreur / Rouge
  static const Color error = Color(0xFFEF4444);
}