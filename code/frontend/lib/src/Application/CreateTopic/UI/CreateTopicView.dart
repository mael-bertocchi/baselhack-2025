import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
import '../../../routes/AppRoutes.dart';
import '../../../widgets/SharedAppBar.dart';
import '../Api/CreateTopicService.dart';
import '../../Login/Api/AuthService.dart';
import 'Components/CustomTextField.dart';
import 'Components/DateTimePickerField.dart';

class CreateTopicView extends StatefulWidget {
  const CreateTopicView({super.key});

  @override
  State<CreateTopicView> createState() => _CreateTopicViewState();
}

class _CreateTopicViewState extends State<CreateTopicView> {
  final _formKey = GlobalKey<FormState>();
  final _createTopicService = CreateTopicService();
  
  // Controllers
  final _titleController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Date/Time values
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Error states
  String? _titleError;
  String? _shortDescriptionError;
  String? _descriptionError;
  String? _startDateError;
  String? _endDateError;
  
  // Loading state
  bool _isSubmitting = false;
  
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

    // Validate title
    if (_titleController.text.trim().isEmpty) {
      setState(() => _titleError = 'Title is required');
      isValid = false;
    } else if (_titleController.text.trim().length < 3) {
      setState(() => _titleError = 'Title must be at least 3 characters');
      isValid = false;
    } else if (_titleController.text.trim().length > 255) {
      setState(() => _titleError = 'Title must not exceed 255 characters');
      isValid = false;
    }

    // Validate short description
    if (_shortDescriptionController.text.trim().isEmpty) {
      setState(() => _shortDescriptionError = 'Short description is required');
      isValid = false;
    } else if (_shortDescriptionController.text.trim().length < 5) {
      setState(() => _shortDescriptionError = 'Short description must be at least 5 characters');
      isValid = false;
    } else if (_shortDescriptionController.text.trim().length > 500) {
      setState(() => _shortDescriptionError = 'Short description must not exceed 500 characters');
      isValid = false;
    }

    // Validate description
    if (_descriptionController.text.trim().isEmpty) {
      setState(() => _descriptionError = 'Description is required');
      isValid = false;
    } else if (_descriptionController.text.trim().length < 10) {
      setState(() => _descriptionError = 'Description must be at least 10 characters');
      isValid = false;
    } else if (_descriptionController.text.trim().length > 2500) {
      setState(() => _descriptionError = 'Description must not exceed 2500 characters');
      isValid = false;
    }

    // Validate dates
    if (_startDate == null) {
      setState(() => _startDateError = 'Start date is required');
      isValid = false;
    }

    if (_endDate == null) {
      setState(() => _endDateError = 'End date is required');
      isValid = false;
    }

    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        setState(() => _endDateError = 'End date must be after start date');
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _handleSubmit() async {
    if (!_validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = AuthService.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _createTopicService.createTopic(
        title: _titleController.text.trim(),
        shortDescription: _shortDescriptionController.text.trim(),
        description: _descriptionController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        authorId: user.id,
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Topic created successfully!'),
              ],
            ),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate back to dashboard with replacement to avoid back button
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Failed to create topic: ${e.toString()}'),
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
    // Show confirmation dialog if there's unsaved content
    if (_titleController.text.isNotEmpty ||
        _shortDescriptionController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _startDate != null ||
        _endDate != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Discard changes?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'You have unsaved changes. Are you sure you want to leave?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Continue Editing',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard); // Force return to dashboard
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
              child: const Text(
                'Discard',
                style: TextStyle(fontWeight: FontWeight.w600),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SharedAppBar(
      ),
      body: SelectionArea(
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
                              Icons.add_circle_outline,
                              color: AppColors.blue,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create a New Discussion Topic',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fill in the details to start a new community discussion',
                                  style: TextStyle(
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
                            label: 'Title',
                            hint: 'Enter a clear and concise title',
                            controller: _titleController,
                            maxLength: 255,
                            errorText: _titleError,
                            prefixIcon: Icons.title,
                            required: true,
                          ),
                          const SizedBox(height: 24),

                          // Short description field
                          CustomTextField(
                            label: 'Short Description',
                            hint: 'Brief overview of the topic (shown in cards)',
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
                            label: 'Full Description',
                            hint: 'Detailed information about the topic',
                            controller: _descriptionController,
                            maxLines: 8,
                            maxLength: 2500,
                            errorText: _descriptionError,
                            prefixIcon: Icons.description,
                            required: true,
                          ),
                          const SizedBox(height: 24),

                          // Date pickers
                          const Text(
                            'Duration',
                            style: TextStyle(
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
                                  label: 'Start Date',
                                  initialDate: _startDate,
                                  firstDate: DateTime.now(),
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
                                  label: 'End Date',
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
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
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
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_circle_outline, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Create Topic',
                                        style: TextStyle(
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
