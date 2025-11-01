import 'package:flutter/material.dart';
import '../theme/AppColors.dart';
import '../Application/Dashboard/UI/Components/ProfileMenu.dart';
import 'package:frontend/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      leading: widget.leading,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'C',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title ?? l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.1,
          ),
          child: IconButton(
            key: _profileButtonKey,
            icon: const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.person, color: AppColors.textSecondary),
            ),
            onPressed: _toggleProfileMenu,
          ),
        ),
      ],
    );
  }
}
