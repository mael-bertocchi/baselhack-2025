import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/AppColors.dart';

class DateTimePickerField extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime) onDateSelected;
  final String? errorText;
  final IconData icon;

  const DateTimePickerField({
    super.key,
    required this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
    this.errorText,
    this.icon = Icons.calendar_today,
  });

  @override
  State<DateTimePickerField> createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.initialDate!);
    }
  }

  Future<void> _pickDate() async {
    final firstDate = widget.firstDate ?? DateTime.now();
    final lastDate = widget.lastDate ?? DateTime.now().add(const Duration(days: 365 * 10));
    
    // S'assurer que initialDate est dans la plage valide
    DateTime initialDate;
    if (_selectedDate != null) {
      initialDate = _selectedDate!;
      // Si la date sélectionnée est avant firstDate, utiliser firstDate
      if (initialDate.isBefore(firstDate)) {
        initialDate = firstDate;
      }
      // Si la date sélectionnée est après lastDate, utiliser lastDate
      if (initialDate.isAfter(lastDate)) {
        initialDate = lastDate;
      }
    } else {
      // Utiliser firstDate par défaut si elle est après maintenant
      initialDate = firstDate.isAfter(DateTime.now()) ? firstDate : DateTime.now();
      // S'assurer qu'on ne dépasse pas lastDate
      if (initialDate.isAfter(lastDate)) {
        initialDate = lastDate;
      }
    }
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      _pickTime();
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null && _selectedDate != null) {
      setState(() {
        _selectedTime = time;
      });

      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        time.hour,
        time.minute,
      );

      widget.onDateSelected(dateTime);
    }
  }

  String _getDisplayText() {
    if (_selectedDate == null) {
      return 'Select ${widget.label.toLowerCase()}';
    }

    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    if (_selectedTime == null) {
      return dateFormat.format(_selectedDate!);
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    return '${dateFormat.format(dateTime)} at ${timeFormat.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final hasValue = _selectedDate != null && _selectedTime != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? AppColors.pink
                    : hasValue
                        ? AppColors.blue
                        : const Color(0xFFE5E7EB),
                width: hasError || hasValue ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: hasError
                      ? AppColors.pink
                      : hasValue
                          ? AppColors.blue
                          : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getDisplayText(),
                    style: TextStyle(
                      fontSize: 16,
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withOpacity(0.6),
                      fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.pink,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
