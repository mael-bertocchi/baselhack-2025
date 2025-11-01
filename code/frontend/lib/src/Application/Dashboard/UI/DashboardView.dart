import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
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

  // Données d'exemple pour les enquêtes
  final List<Survey> _surveys = const [
    Survey(
      title: 'Digital Transformation Strategy',
      description: 'How should we prioritize digital initiatives across the organization?',
      status: 'Closed',
      category: 'Strategy',
      ideasCount: 24,
      participantsCount: 18,
    ),
    Survey(
      title: 'Workplace Flexibility',
      description: 'What flexible work arrangements would improve productivity?',
      status: 'Soon',
      category: 'HR',
      ideasCount: 32,
      participantsCount: 25,
    ),
    Survey(
      title: 'Product Innovation',
      description: 'What new features should we develop for our next product release?',
      status: 'Active',
      category: 'Product',
      ideasCount: 18,
      participantsCount: 14,
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
    _searchController.addListener(_filterSurveys);
  }

  void _filterSurveys() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSurveys = _surveys;
      } else {
        _filteredSurveys = _surveys.where((survey) {
          return survey.title.toLowerCase().contains(query) ||
              survey.description.toLowerCase().contains(query) ||
              survey.category.toLowerCase().contains(query) ||
              survey.status.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

              // Barre de recherche
              TextField(
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
                          // TODO: Navigation vers la page de détail de l'enquête
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Opening ${_filteredSurveys[index].title}',
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
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