import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import 'package:alignify/src/Application/Shared/Api/AuthService.dart';
import 'package:alignify/src/Application/Shared/Models/Models.dart';
import '../../../Common/LocaleProvider.dart';
import '../../../../routes/AppRoutes.dart';

/// Menu profil avec sélecteur de langue et déconnexion
class ProfileMenu extends StatelessWidget {
  final VoidCallback onClose;

  const ProfileMenu({
    super.key,
    required this.onClose,
  });

  void _changeLanguage(BuildContext context, String languageCode) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.setLocale(Locale(languageCode));
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Close menu first
      onClose();
      
      // Logout from AuthService (clears tokens from storage)
      await AuthService.instance.logout();
      
      // Navigate to login page
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      }
    } catch (e) {
      // Show error if logout fails
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.logoutFailed(e.toString())),
            backgroundColor: AppColors.pink,
          ),
        );
      }
    }
  }

  String _getRoleDisplay(BuildContext context, Role? role) {
    final l10n = AppLocalizations.of(context)!;
    if (role == null) return l10n.user;
    switch (role) {
      case Role.administrator:
        return l10n.administrator;
      case Role.manager:
        return l10n.manager;
      case Role.user:
        return l10n.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = AuthService.instance.currentUser;
    final userName = user != null
        ? '${user.firstName} ${user.lastName}'.trim().isNotEmpty
            ? '${user.firstName} ${user.lastName}'.trim()
            : user.email
        : l10n.user;
    
    // Get user initials
    String initials = '';
    if (user != null) {
      final firstName = user.firstName.trim();
      final lastName = user.lastName.trim();
      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        initials = firstName[0].toUpperCase() + lastName[0].toUpperCase();
      } else if (firstName.isNotEmpty) {
        initials = firstName[0].toUpperCase();
      } else if (lastName.isNotEmpty) {
        initials = lastName[0].toUpperCase();
      } else if (user.email.isNotEmpty) {
        initials = user.email[0].toUpperCase();
      }
    }

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Container(
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with user info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.background,
                      radius: 20,
                      child: initials.isNotEmpty
                          ? Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getRoleDisplay(context, user?.role),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Language selector
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          _buildLanguageButton(context, '🇫🇷', 'fr', localeProvider.locale.languageCode),
                          _buildLanguageButton(context, '🇬🇧', 'en', localeProvider.locale.languageCode),
                          _buildLanguageButton(context, '🇩🇪', 'de', localeProvider.locale.languageCode),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Manage Accounts button (only for administrators)
              if (user?.role == Role.administrator)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: InkWell(
                    onTap: () {
                      onClose();
                      Navigator.of(context).pushNamed(AppRoutes.manageAccounts);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.manage_accounts,
                            color: AppColors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.manageAccounts,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Logout button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: InkWell(
                  onTap: () => _handleLogout(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: AppColors.pink,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.logout,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton(BuildContext context, String emoji, String languageCode, String currentLanguage) {
    final isSelected = currentLanguage == languageCode;

    return Expanded(
      child: InkWell(
        onTap: () => _changeLanguage(context, languageCode),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 20,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
