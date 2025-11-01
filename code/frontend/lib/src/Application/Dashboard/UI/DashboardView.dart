import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import '../../../theme/AppColors.dart';
import 'package:frontend/src/Application/Dashboard/UI/TopicDetail/UI/TopicDetailView.dart';
import 'Components/StatCard.dart';
import 'Components/TopicCard.dart';
import 'Components/ProfileMenu.dart';
import '../Api/DashboardService.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final TextEditingController _searchController = TextEditingController();
  final DashboardApiService _apiService = DashboardApiService();
  
  List<Topic> _topics = [];
  List<Topic> _filteredTopics = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // Variables de filtre et tri
  String _selectedStatus = 'all'; // 'all', 'Active', 'Closed', 'Scheduled', 'Archived'
  
  // Profile menu
  OverlayEntry? _profileMenuOverlay;
  final GlobalKey _profileButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final topics = await _apiService.getTopics();
      setState(() {
        _topics = topics;
        _filteredTopics = topics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load topics: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Filtrage par recherche textuelle
      List<Topic> filtered = _topics;
      
      if (query.isNotEmpty) {
        filtered = filtered.where((topic) {
          return topic.title.toLowerCase().contains(query) ||
              topic.shortDescription.toLowerCase().contains(query) ||
              topic.description.toLowerCase().contains(query) ||
              topic.statusDisplay.toLowerCase().contains(query);
        }).toList();
      }
      
      // Filtrage par statut
      if (_selectedStatus != 'all') {
        filtered = filtered.where((topic) => topic.statusDisplay == _selectedStatus).toList();
      }
      
      _filteredTopics = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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

  // Widget pour la barre de recherche
  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 56, // Hauteur fixe
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: l10n.searchTopics,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.6),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.blue,
            size: 24,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Widget pour le filtre de statut (design amélioré avec chips)
  Widget _buildStatusFilter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statuses = [
      {'value': 'all', 'label': l10n.allTopics, 'icon': Icons.grid_view},
      {'value': 'Active', 'label': l10n.active, 'icon': Icons.play_circle_outline},
      {'value': 'Scheduled', 'label': l10n.scheduled, 'icon': Icons.schedule},
      {'value': 'Closed', 'label': l10n.closed, 'icon': Icons.check_circle_outline},
    ];

    return SizedBox(
      height: 48, // Hauteur fixe identique à la search bar
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
          final isSelected = _selectedStatus == status['value'];
          Color backgroundColor;
          Color textColor;
          
          if (isSelected) {
            switch (status['value']) {
              case 'Active':
                backgroundColor = const Color(0xFFF3E8FF);
                textColor = const Color(0xFF7C3AED);
                break;
              case 'Soon':
                backgroundColor = const Color(0xFFFCE7F3);
                textColor = const Color(0xFFEC4899);
                break;
              case 'Closed':
                backgroundColor = const Color(0xFFCCFBF1);
                textColor = const Color(0xFF14B8A6);
                break;
              default:
                backgroundColor = const Color(0xFFDCEEFE);
                textColor = AppColors.blue;
            }
          } else {
            backgroundColor = Colors.transparent;
            textColor = AppColors.textSecondary;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedStatus = status['value'] as String;
                  _applyFilters();
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: textColor, width: 1)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status['icon'] as IconData,
                      size: 18,
                      color: textColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
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
            SelectableText(
              l10n.appTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: _profileButtonKey,
            icon: const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.person, color: AppColors.textSecondary),
            ),
            onPressed: _toggleProfileMenu,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SelectionArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.blue,
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.pink,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.errorLoadingTopics,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadTopics,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.tryAgain),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec titre et sous-titre
              const SelectableText(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const SelectableText(
                'Share your diverse perspectives and help shape better decisions together',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Cartes de statistiques
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  
                  if (isWide) {
                    return Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Active Topics',
                            value: '5',
                            icon: Icons.trending_up,
                            iconColor: AppColors.blue,
                            borderColor: AppColors.blue,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: StatCard(
                            label: 'Your Contributions',
                            value: '12',
                            icon: Icons.chat_bubble_outline,
                            iconColor: AppColors.pink,
                            borderColor: AppColors.pink,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: StatCard(
                            label: 'Total Participants',
                            value: '847',
                            icon: Icons.people_outline,
                            iconColor: AppColors.blue,
                            borderColor: AppColors.blue,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        StatCard(
                          label: 'Active Topics',
                          value: '5',
                          icon: Icons.trending_up,
                          iconColor: AppColors.blue,
                          borderColor: AppColors.blue,
                        ),
                        const SizedBox(height: 16),
                        StatCard(
                          label: 'Your Contributions',
                          value: '12',
                          icon: Icons.chat_bubble_outline,
                          iconColor: AppColors.pink,
                          borderColor: AppColors.pink,
                        ),
                        const SizedBox(height: 16),
                        StatCard(
                          label: 'Total Participants',
                          value: '847',
                          icon: Icons.people_outline,
                          iconColor: AppColors.blue,
                          borderColor: AppColors.blue,
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 40),

              // Barre de recherche et filtres
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  
                  if (isWide) {
                    // Version desktop - tout sur une ligne
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Barre de recherche
                        Expanded(
                          child: _buildSearchBar(context),
                        ),
                        const SizedBox(width: 16),
                        
                        // Filtre par statut
                        _buildStatusFilter(context),
                      ],
                    );
                  } else {
                    // Version mobile - empilé verticalement
                    return Column(
                      children: [
                        _buildSearchBar(context),
                        const SizedBox(height: 16),
                        _buildStatusFilter(context),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 32),

              // Message si aucun résultat
              if (_filteredTopics.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        SelectableText(
                          l10n.noTopicsFound,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          l10n.tryAdjustingSearch,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Grille de topics
                LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 3
                      : constraints.maxWidth > 800
                          ? 2
                          : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: _filteredTopics.length,
                    itemBuilder: (context, index) {
                      return TopicCard(
                        topic: _filteredTopics[index],
                        onViewTopic: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TopicDetailView(
                                topic: _filteredTopics[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        ),
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreateTopic,
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              elevation: 4,
              icon: const Icon(Icons.add, size: 24),
              label: Text(
                l10n.createTopic,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}