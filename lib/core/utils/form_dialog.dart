import 'package:flutter/material.dart';

/// A class that defines various validation rules for form fields.
/// Each rule is optional and can be combined with others.
@immutable
class ValidationRules {
  /// Validates if the input contains only numeric values
  final bool? numeric;

  /// Validates if the input contains only text (no numbers)
  final bool? text;

  /// Minimum length of the input
  final int? min;

  /// Maximum length of the input
  final int? max;

  /// Validates if the input is a properly formatted email
  final bool? email;

  /// Custom regex pattern for advanced validation
  final String? regex;

  /// Custom error message for regex validation
  final String? customError;

  const ValidationRules({
    this.numeric,
    this.text,
    this.min,
    this.max,
    this.email,
    this.regex,
    this.customError,
  });

  /// Creates validation rules specifically for email fields
  const factory ValidationRules.email() = _EmailValidationRules;

  /// Creates validation rules for numeric-only fields
  factory ValidationRules.numeric({int? min, int? max}) {
    return ValidationRules(
      numeric: true,
      min: min,
      max: max,
    );
  }

  /// Creates validation rules for text-only fields
  factory ValidationRules.text({int? min, int? max}) {
    return ValidationRules(
      text: true,
      min: min,
      max: max,
    );
  }

  /// Creates validation rules for password fields
  factory ValidationRules.password({int min = 6, int? max}) {
    return ValidationRules(
      min: min,
      max: max,
    );
  }
}

class _EmailValidationRules extends ValidationRules {
  const _EmailValidationRules() : super(email: true);
}

/// Represents a single field in the dynamic form
@immutable
class DynamicFormField {
  /// Key used to identify the field in the form results
  final String key;

  /// Label text shown above the field
  final String label;

  /// Optional hint text shown inside the field
  final String? hint;

  /// Keyboard type for the field (e.g., number, email, text)
  final TextInputType keyboardType;

  /// Whether the field is required or optional
  final bool isRequired;

  /// Whether the field should obscure text (for passwords)
  final bool isObscure;

  /// Validation rules for the field
  final ValidationRules? validationRules;

  const DynamicFormField({
    String? key,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isRequired = true,
    this.isObscure = false,
    this.validationRules,
  }) : key = key ?? label;

  /// Creates an email form field with appropriate keyboard type and validation
  factory DynamicFormField.email({
    String? key,
    String label = 'Email',
    String? hint,
    bool isRequired = true,
  }) {
    return DynamicFormField(
      key: key,
      label: label,
      hint: hint,
      keyboardType: TextInputType.emailAddress,
      isRequired: isRequired,
      validationRules: const ValidationRules.email(),
    );
  }

  /// Creates a password form field with appropriate keyboard type and validation
  factory DynamicFormField.password({
    String? key,
    String label = 'Password',
    String? hint,
    bool isRequired = true,
    int minLength = 6,
    int? maxLength,
  }) {
    return DynamicFormField(
      key: key,
      label: label,
      hint: hint ?? 'Enter your password',
      keyboardType: TextInputType.visiblePassword,
      isRequired: isRequired,
      isObscure: true,
      validationRules: ValidationRules.password(min: minLength, max: maxLength),
    );
  }
}

/// A dialog widget that displays a dynamic form based on provided field configurations
class FormDialog extends StatefulWidget {
  /// List of form fields to display
  final List<DynamicFormField> fields;

  /// Dialog title
  final String title;

  /// Text for the submit button
  final String submitButtonText;

  /// Text for the cancel button
  final String cancelButtonText;

  /// Border radius for the dialog
  final double borderRadius;

  /// Callback function called when form is submitted with valid data
  final Function(Map<String, String>) onConfirm;

  const FormDialog({
    super.key,
    required this.fields,
    this.title = 'Enter Information',
    this.submitButtonText = 'Submit',
    this.cancelButtonText = 'Cancel',
    this.borderRadius = 15,
    required this.onConfirm,
  });

  /// Shows the form dialog with the specified configuration
  static Future<void> show({
    required BuildContext context,
    required List<DynamicFormField> fields,
    required Function(Map<String, String>) onConfirm,
    String title = 'Enter Information',
    String submitButtonText = 'Submit',
    String cancelButtonText = 'Cancel',
    double borderRadius = 15,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => FormDialog(
        fields: fields,
        title: title,
        submitButtonText: submitButtonText,
        cancelButtonText: cancelButtonText,
        borderRadius: borderRadius,
        onConfirm: (result) {
          // Call onConfirm before popping dialog
          onConfirm(result);
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _obscureStates = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _controllers[field.key] = TextEditingController();
      if (field.isObscure) {
        _obscureStates[field.key] = true;
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Validates a single field based on its validation rules
  String? _validateField(String? value, DynamicFormField field) {
    if (field.isRequired && (value == null || value.isEmpty)) {
      return '${field.label} is required';
    }

    if (value != null && value.isNotEmpty && field.validationRules != null) {
      final rules = field.validationRules!;

      // Numeric validation
      if (rules.numeric == true) {
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
      }

      // Text-only validation
      if (rules.text == true) {
        if (RegExp(r'[0-9]').hasMatch(value)) {
          return 'Please enter text only';
        }
      }

      // Min length validation
      if (rules.min != null && value.length < rules.min!) {
        return 'Minimum ${rules.min} characters required';
      }

      // Max length validation
      if (rules.max != null && value.length > rules.max!) {
        return 'Maximum ${rules.max} characters allowed';
      }

      // Email validation
      if (rules.email == true) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      }

      // Custom regex validation
      if (rules.regex != null) {
        final regExp = RegExp(rules.regex!);
        if (!regExp.hasMatch(value)) {
          return rules.customError ?? 'Invalid format';
        }
      }
    }

    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final result = Map<String, String>.fromEntries(
        _controllers.entries.map(
          (e) => MapEntry(e.key, e.value.text),
        ),
      );
      widget.onConfirm(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.fields.map((field) {
              final isObscured = _obscureStates[field.key] ?? false;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _controllers[field.key],
                  decoration: InputDecoration(
                    labelText: field.label,
                    hintText: field.hint,
                    border: const OutlineInputBorder(),
                    suffixIcon: field.isObscure
                        ? IconButton(
                            icon: Icon(
                              isObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureStates[field.key] = !isObscured;
                              });
                            },
                          )
                        : null,
                  ),
                  keyboardType: field.keyboardType,
                  obscureText: isObscured,
                  validator: (value) => _validateField(value, field),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelButtonText),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          child: Text(widget.submitButtonText),
        ),
      ],
    );
  }
}