import 'package:flutter/material.dart';
import 'package:ordering_app/core/common/entities/product_option_entity.dart';

class ProductOptionsSelector extends StatelessWidget {
  final List<ProductOptionEntity> options;
  final Map<String, List<String>> selectedOptions;
  final Function(String, List<String>) onOptionSelected;

  const ProductOptionsSelector({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
  });

  Widget _buildOptionField(
      ProductOptionEntity option, ThemeData theme, BuildContext context) {
    switch (option.type) {
      case 'select':
        return DropdownButtonFormField<String>(
          value: selectedOptions[option.productOptionId]?.firstOrNull,
          decoration: InputDecoration(
            labelText: '${option.name}${option.required == "1" ? " *" : ""}',
          ),
          items: option.optionValue.map((value) {
            String priceText = '';
            if (value.price) {
              priceText = ' (${value.pricePrefix}\$${value.priceValue})';
            }
            return DropdownMenuItem(
              value: value.productOptionValueId,
              child: Text('${value.name}$priceText'),
            );
          }).toList(),
          onChanged: option.required == "1" ? (value) {
            if (value != null) {
              onOptionSelected(option.productOptionId, [value]);
            }
          } : null,
        );

      case 'radio':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${option.name}${option.required == "1" ? " *" : ""}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...option.optionValue.map((value) {
              String priceText = '';
              if (value.price) {
                priceText = ' (${value.pricePrefix}\$${value.priceValue})';
              }
              return RadioListTile<String>(
                title: Text('${value.name}$priceText'),
                value: value.productOptionValueId,
                groupValue: selectedOptions[option.productOptionId]?.firstOrNull,
                onChanged: option.required == "1" ? (newValue) {
                  if (newValue != null) {
                    onOptionSelected(option.productOptionId, [newValue]);
                  }
                } : null,
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        );

      case 'checkbox':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${option.name}${option.required == "1" ? " *" : ""}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...option.optionValue.map((value) {
              String priceText = '';
              if (value.price) {
                priceText = ' (${value.pricePrefix}\$${value.priceValue})';
              }
              bool isSelected = selectedOptions[option.productOptionId]
                      ?.contains(value.productOptionValueId) ??
                  false;
              return CheckboxListTile(
                title: Text('${value.name}$priceText'),
                value: isSelected,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    List<String> currentValues =
                        List.from(selectedOptions[option.productOptionId] ?? []);
                    if (newValue) {
                      currentValues.add(value.productOptionValueId);
                    } else {
                      currentValues.remove(value.productOptionValueId);
                    }
                    onOptionSelected(option.productOptionId, currentValues);
                  }
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        );

      case 'text':
        return TextFormField(
          initialValue: selectedOptions[option.productOptionId]?.firstOrNull,
          decoration: InputDecoration(
            labelText: '${option.name}${option.required == "1" ? " *" : ""}',
            hintText:
                option.defaultValue.isNotEmpty ? option.defaultValue : null,
          ),
          onChanged: (value) {
            onOptionSelected(option.productOptionId, [value]);
          },
        );

      case 'textarea':
        return TextFormField(
          initialValue: selectedOptions[option.productOptionId]?.firstOrNull,
          decoration: InputDecoration(
            labelText: '${option.name}${option.required == "1" ? " *" : ""}',
            hintText:
                option.defaultValue.isNotEmpty ? option.defaultValue : null,
          ),
          maxLines: 3,
          onChanged: (value) {
            onOptionSelected(option.productOptionId, [value]);
          },
        );

      case 'file':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${option.name}${option.required == "1" ? " *" : ""}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement file picker
              },
              icon: const Icon(Icons.upload_file),
              label: Text(
                  selectedOptions[option.productOptionId]?.firstOrNull?.isNotEmpty == true
                      ? selectedOptions[option.productOptionId]!.first
                      : 'Choose File'),
            ),
          ],
        );

      case 'date':
        return TextFormField(
          controller: TextEditingController(
            text: selectedOptions[option.productOptionId]?.firstOrNull ?? '',
          ),
          decoration: InputDecoration(
            labelText: '${option.name}${option.required == "1" ? " *" : ""}',
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              final String formattedDate = 
                '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
              onOptionSelected(
                option.productOptionId,
                [formattedDate],
              );
            }
          },
        );

      case 'time':
        return TextFormField(
          controller: TextEditingController(
            text: selectedOptions[option.productOptionId]?.firstOrNull ?? '',
          ),
          decoration: InputDecoration(
            labelText: '${option.name}${option.required == "1" ? " *" : ""}',
            suffixIcon: const Icon(Icons.access_time),
          ),
          readOnly: true,
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              final String formattedTime =
                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
              onOptionSelected(
                option.productOptionId,
                [formattedTime],
              );
            }
          },
        );

      case 'datetime':
        return TextFormField(
          controller: TextEditingController(
            text: selectedOptions[option.productOptionId]?.firstOrNull ?? '',
          ),
          decoration: InputDecoration(
            labelText: '${option.name}${option.required == "1" ? " *" : ""}',
            suffixIcon: const Icon(Icons.event),
          ),
          readOnly: true,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null && context.mounted) {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                final String formattedDateTime =
                  '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} '
                  '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00';
                onOptionSelected(
                  option.productOptionId,
                  [formattedDateTime],
                );
              }
            }
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildOptionField(option, theme, context),
        );
      }).toList(),
    );
  }
}