import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
import '../../../pages/SurveyDetail/SurveyDetailPage.dart';
import 'Components/StatCard.dart';
import 'Components/SurveyCard.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final TextEditingController _searchController = TextEditingController();
  List<Survey> _filteredSurveys = [];
  
  // Variables de filtre et tri
  String _selectedStatus = 'all'; // 'all', 'Active', 'Closed', 'Soon'

  // Données d'exemple pour les enquêtes
  final List<Survey> _surveys = const [
    Survey(
      title: 'Digital Transformation Strategy',
      description: 'How should we prioritize digital initiatives across the organization?',
      status: 'Active',
      category: 'Strategy',
      ideasCount: 24,
      participantsCount: 18,
      createdBy: 'Michael Chen',
      context: 'Our organization is at a critical juncture in our digital journey. We need diverse perspectives from team members across all departments to make informed decisions about our digital transformation priorities.',
      lookingFor: [
        'Specific ideas and recommendations',
        'Concerns or risks you foresee',
        'Resources or skills needed',
        'Timeline and priority suggestions',
      ],
      guidelines: [
        'Be specific and actionable',
        'Consider cross-departmental impact',
        'Think both short-term and long-term',
        'Focus on feasibility alongside innovation',
      ],
      timeline: 'Submissions close: December 15, 2024\nReview period: December 16-31, 2024\nDecision announcement: January 15, 2025',
    ),
    Survey(
      title: 'Workplace Flexibility',
      description: 'What flexible work arrangements would improve productivity?',
      status: 'Soon',
      category: 'HR',
      ideasCount: 32,
      participantsCount: 25,
      createdBy: 'Sarah Johnson',
      context: 'As we evolve our workplace policies, we want to understand what flexibility options would best support our team\'s productivity and work-life balance.',
      lookingFor: [
        'Preferred working arrangements',
        'Productivity concerns or benefits',
        'Technology or tools needed',
        'Communication strategies',
      ],
      guidelines: [
        'Consider team collaboration needs',
        'Think about work-life balance',
        'Be realistic about constraints',
        'Share your personal experience',
      ],
      timeline: 'Survey opens: December 1, 2024\nSubmissions close: January 15, 2025\nImplementation: February 2025',
    ),
    Survey(
      title: 'Product Innovation',
      description: 'What new features should we develop for our next product release?',
      status: 'Active',
      category: 'Product',
      ideasCount: 18,
      participantsCount: 14,
      createdBy: 'Alex Rodriguez',
      context: 'We\'re planning our Q2 2025 product roadmap and need input on features that will deliver the most value to our customers.',
      lookingFor: [
        'Feature ideas and use cases',
        'Customer pain points to address',
        'Market opportunities',
        'Technical feasibility considerations',
      ],
      guidelines: [
        'Focus on customer value',
        'Consider implementation complexity',
        'Think about scalability',
        'Include competitive analysis',
      ],
      timeline: 'Submissions close: December 20, 2024\nPrioritization: January 2025\nDevelopment starts: February 2025',
    ),
    Survey(
      title: 'Sustainability Goals',
      description: 'How can we reduce our environmental impact?',
      status: 'Closed',
      category: 'Sustainability',
      ideasCount: 42,
      participantsCount: 31,
    ),
    Survey(
      title: 'Customer Experience',
      description: 'What improvements would enhance customer satisfaction?',
      status: 'Active',
      category: 'Customer',
      ideasCount: 15,
      participantsCount: 12,
    ),
    Survey(
      title: 'Team Collaboration Tools',
      description: 'Which tools would best support our team collaboration?',
      status: 'Active',
      category: 'Operations',
      ideasCount: 28,
      participantsCount: 22,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredSurveys = _surveys;
    _searchController.addListener(_applyFilters);
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Filtrage par recherche textuelle
      List<Survey> filtered = _surveys;
      
      if (query.isNotEmpty) {
        filtered = filtered.where((survey) {
          return survey.title.toLowerCase().contains(query) ||
              survey.description.toLowerCase().contains(query) ||
              survey.category.toLowerCase().contains(query) ||
              survey.status.toLowerCase().contains(query);
        }).toList();
      }
      
      // Filtrage par statut
      if (_selectedStatus != 'all') {
        filtered = filtered.where((survey) => survey.status == _selectedStatus).toList();
      }
      
      _filteredSurveys = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Widget pour la barre de recherche
  Widget _buildSearchBar() {
    return SizedBox(
      height: 56, // Hauteur fixe
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search surveys...',
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
  Widget _buildStatusFilter() {
    final statuses = [
      {'value': 'all', 'label': 'All', 'icon': Icons.grid_view},
      {'value': 'Active', 'label': 'Active', 'icon': Icons.play_circle_outline},
      {'value': 'Soon', 'label': 'Soon', 'icon': Icons.schedule},
      {'value': 'Closed', 'label': 'Closed', 'icon': Icons.check_circle_outline},
    ];

    return Container(
      height: 56, // Hauteur fixe identique à la search bar
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  vertical: 8,
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const SelectableText(
              'Consensus Hub',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.person, color: AppColors.textSecondary),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
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
                            label: 'Active Surveys',
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
                          label: 'Active Surveys',
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
                          child: _buildSearchBar(),
                        ),
                        const SizedBox(width: 16),
                        
                        // Filtre par statut
                        _buildStatusFilter(),
                      ],
                    );
                  } else {
                    // Version mobile - empilé verticalement
                    return Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 16),
                        _buildStatusFilter(),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 32),

              // Message si aucun résultat
              if (_filteredSurveys.isEmpty)
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
                          'No surveys found',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          'Try adjusting your search terms',
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
                // Grille d'enquêtes
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
                    itemCount: _filteredSurveys.length,
                    itemBuilder: (context, index) {
                      return SurveyCard(
                        survey: _filteredSurveys[index],
                        onViewSurvey: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SurveyDetailPage(
                                survey: _filteredSurveys[index],
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
    );
  }
}