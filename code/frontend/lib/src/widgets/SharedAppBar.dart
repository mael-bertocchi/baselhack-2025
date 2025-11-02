import 'package:flutter/material.dart';
import '../theme/AppColors.dart';
import '../Application/Dashboard/UI/Components/ProfileMenu.dart';
import '../routes/AppRoutes.dart';
import 'package:alignify/src/Application/Shared/Api/AuthService.dart';

/// Shared AppBar component used across the application
/// Provides consistent branding and profile menu functionality
class SharedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;

  const SharedAppBar({
    super.key,
    this.title,
    this.leading,
  });

  @override
  State<SharedAppBar> createState() => _SharedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _SharedAppBarState extends State<SharedAppBar> {
  OverlayEntry? _profileMenuOverlay;
  final GlobalKey _profileButtonKey = GlobalKey();

  @override
  void dispose() {
    _removeProfileMenu();
    super.dispose();
  }

  void _toggleProfileMenu() {
    if (_profileMenuOverlay != null) {
      _removeProfileMenu();
    } else {
      _showProfileMenu();
    }
  }

  void _showProfileMenu() {
    final RenderBox? renderBox = _profileButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _profileMenuOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop to close menu when clicking outside
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeProfileMenu,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Profile menu
          Positioned(
            top: offset.dy + size.height + 8,
            right: MediaQuery.of(context).size.width - offset.dx - size.width,
            child: Material(
              color: Colors.transparent,
              child: ProfileMenu(
                onClose: _removeProfileMenu,
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_profileMenuOverlay!);
  }

  void _removeProfileMenu() {
    _profileMenuOverlay?.remove();
    _profileMenuOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final horizontalPadding = isMobile ? 16.0 : MediaQuery.of(context).size.width * 0.1;
    final user = AuthService.instance.currentUser;
    
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
    
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      leading: widget.leading,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.dashboard,
                  (route) => false,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/alignify_logo.png',
                  height: isMobile ? 80 : 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: horizontalPadding,
          ),
          child: IconButton(
            key: _profileButtonKey,
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.blue,
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.background,
                child: initials.isNotEmpty
                    ? Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      )
                    : const Icon(Icons.person, color: AppColors.textSecondary),
              ),
            ),
            onPressed: _toggleProfileMenu,
          ),
        ),
      ],
    );
  }
}
