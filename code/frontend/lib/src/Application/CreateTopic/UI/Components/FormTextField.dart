import 'package:flutter/material.dart';
import 'package:alignify/src/Application/Shared/UI/CustomTextField.dart' as SharedUI;

/// A wrapper around the shared CustomTextField that provides a simplified interface
/// for forms that need basic text fields with label, hint, and validation.
class FormTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final String? errorText;
  final IconData? prefixIcon;
  final bool required;
  final TextInputType? keyboardType;

  const FormTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.errorText,
    this.prefixIcon,
    this.required = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    // Build label with optional required indicator
    String labelText = label;
    if (required) {
      labelText = '$label *';
    }

    return SharedUI.CustomTextField(
      controller: controller,
      labelText: labelText,
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
    );
  }
}
