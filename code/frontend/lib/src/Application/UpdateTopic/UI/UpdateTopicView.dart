import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import '../../../theme/AppColors.dart';
import '../../../routes/AppRoutes.dart';
import '../../../widgets/SharedAppBar.dart';
import '../Api/UpdateTopicService.dart';
import '../../CreateTopic/UI/Components/CustomTextField.dart';
import '../../CreateTopic/UI/Components/DateTimePickerField.dart';
import '../../Dashboard/UI/Components/TopicCard.dart';
import '../../Dashboard/Api/DashboardService.dart';

class UpdateTopicView extends StatefulWidget {
  final String topicId;

  const UpdateTopicView({
    super.key,
    required this.topicId,
  });

  @override
  State<UpdateTopicView> createState() => _UpdateTopicViewState();
}

class _UpdateTopicViewState extends State<UpdateTopicView> {
  final _formKey = GlobalKey<FormState>();
  final _updateTopicService = UpdateTopicService();
  final _dashboardService = DashboardApiService();
  
  // Controllers
  late final TextEditingController _titleController;
  late final TextEditingController _shortDescriptionController;
  late final TextEditingController _descriptionController;
  
  // Date/Time values
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Topic data
  Topic? _topic;
  
  // Error states
  String? _titleError;
  String? _shortDescriptionError;
  String? _descriptionError;
  String? _startDateError;
  String? _endDateError;
  
  // Loading states
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _loadError;
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values first
    _titleController = TextEditingController();
    _shortDescriptionController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadTopicData();
  }
  
  /// Load topic data from API
  Future<void> _loadTopicData() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final topic = await _dashboardService.getTopicById(widget.topicId);
      
      if (topic == null) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _loadError = l10n.topicNotFound;
          _isLoading = false;
        });
        return;
      }
      
      // Pre-fill form with existing topic data
      setState(() {
        _topic = topic;
        _titleController.text = topic.title;
        _shortDescriptionController.text = topic.shortDescription;
        _descriptionController.text = topic.description;
        _startDate = topic.startDate;
        _endDate = topic.endDate;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _loadError = l10n.failedToLoadTopic(e.toString());
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescriptionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _titleError = null;
      _shortDescriptionError = null;
      _descriptionError = null;
      _startDateError = null;
      _endDateError = null;
    });
  }

  bool _validate() {
    _clearErrors();
    bool isValid = true;
    final l10n = AppLocalizations.of(context)!;

    // Validate title
    if (_titleController.text.trim().isEmpty) {
      setState(() => _titleError = l10n.titleRequired);
      isValid = false;
    } else if (_titleController.text.trim().length < 3) {
      setState(() => _titleError = l10n.titleMinLength);
      isValid = false;
    } else if (_titleController.text.trim().length > 255) {
      setState(() => _titleError = l10n.titleMaxLength);
      isValid = false;
    }

    // Validate short description
    if (_shortDescriptionController.text.trim().isEmpty) {
      setState(() => _shortDescriptionError = l10n.shortDescriptionRequired);
      isValid = false;
    } else if (_shortDescriptionController.text.trim().length < 5) {
      setState(() => _shortDescriptionError = l10n.shortDescriptionMinLength);
      isValid = false;
    } else if (_shortDescriptionController.text.trim().length > 500) {
      setState(() => _shortDescriptionError = l10n.shortDescriptionMaxLength);
      isValid = false;
    }

    // Validate description
    if (_descriptionController.text.trim().isEmpty) {
      setState(() => _descriptionError = l10n.descriptionRequired);
      isValid = false;
    } else if (_descriptionController.text.trim().length < 10) {
      setState(() => _descriptionError = l10n.descriptionMinLength);
      isValid = false;
    } else if (_descriptionController.text.trim().length > 2500) {
      setState(() => _descriptionError = l10n.descriptionMaxLength);
      isValid = false;
    }

    // Validate dates
    if (_startDate == null) {
      setState(() => _startDateError = l10n.startDateRequired);
      isValid = false;
    }

    if (_endDate == null) {
      setState(() => _endDateError = l10n.endDateRequired);
      isValid = false;
    }

    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        setState(() => _endDateError = l10n.endDateAfterStart);
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _handleSubmit() async {
    if (!_validate()) {
      return;
    }
    
    if (_topic == null) return;

    setState(() => _isSubmitting = true);

    try {
      await _updateTopicService.updateTopic(
        id: _topic!.id!,
        title: _titleController.text.trim(),
        shortDescription: _shortDescriptionController.text.trim(),
        description: _descriptionController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        authorId: _topic!.authorId,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(l10n.topicUpdatedSuccessfully),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back to dashboard with replacement to avoid back button
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.failedToUpdateTopic(e.toString())),
                ),
              ],
            ),
            backgroundColor: AppColors.pink,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _handleCancel() {
    if (_topic == null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      return;
    }
    
    // Show confirmation dialog if there are changes
    final hasChanges = _titleController.text != _topic!.title ||
        _shortDescriptionController.text != _topic!.shortDescription ||
        _descriptionController.text != _topic!.description ||
        _startDate != _topic!.startDate ||
        _endDate != _topic!.endDate;

    if (hasChanges) {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.discardChanges,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: Text(
            l10n.unsavedChangesMessage,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.continueEditing,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.discard,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SharedAppBar(
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue,
              ),
            )
          : _loadError != null
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
                          l10n.errorLoadingTopic,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _loadError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadTopicData,
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
              : SelectionArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth * 0.1;
              return Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: 32.0,
                  bottom: 32.0,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.blue,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.updateDiscussionTopic,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.modifyDetailsMessage,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form fields
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title field
                          CustomTextField(
                            label: l10n.title,
                            hint: l10n.titleHint,
                            controller: _titleController,
                            maxLength: 255,
                            errorText: _titleError,
                            prefixIcon: Icons.title,
                            required: true,
                          ),
                          const SizedBox(height: 24),

                          // Short description field
                          CustomTextField(
                            label: l10n.shortDescription,
                            hint: l10n.shortDescriptionHint,
                            controller: _shortDescriptionController,
                            maxLines: 3,
                            maxLength: 500,
                            errorText: _shortDescriptionError,
                            prefixIcon: Icons.short_text,
                            required: true,
                          ),
                          const SizedBox(height: 24),

                          // Description field
                          CustomTextField(
                            label: l10n.fullDescription,
                            hint: l10n.fullDescriptionHint,
                            controller: _descriptionController,
                            maxLines: 8,
                            maxLength: 2500,
                            errorText: _descriptionError,
                            prefixIcon: Icons.description,
                            required: true,
                          ),
                          const SizedBox(height: 24),

                          // Date pickers
                          Text(
                            l10n.duration,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: DateTimePickerField(
                                  label: l10n.startDate,
                                  initialDate: _startDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  onDateSelected: (date) {
                                    setState(() {
                                      _startDate = date;
                                      _startDateError = null;
                                    });
                                  },
                                  errorText: _startDateError,
                                  icon: Icons.event_available,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DateTimePickerField(
                                  label: l10n.endDate,
                                  initialDate: _endDate,
                                  firstDate: _startDate ?? DateTime.now(),
                                  onDateSelected: (date) {
                                    setState(() {
                                      _endDate = date;
                                      _endDateError = null;
                                    });
                                  },
                                  errorText: _endDateError,
                                  icon: Icons.event_busy,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSubmitting ? null : _handleCancel,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              l10n.cancel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: AppColors.blue.withOpacity(0.5),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.save_outlined, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.updateTopic,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
