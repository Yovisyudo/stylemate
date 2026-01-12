import 'package:flutter/material.dart';
import 'package:stylemate/features/auth/presentation/pages/app_constant.dart';


class StyleDropdownField extends StatefulWidget {
  final bool isTablet;
  final Function(String?) onChanged;

  const StyleDropdownField({
    super.key,
    required this.isTablet,
    required this.onChanged,
  });

  @override
  State<StyleDropdownField> createState() => _StyleDropdownFieldState();
}

class _StyleDropdownFieldState extends State<StyleDropdownField> {
  String? _selectedStyle;
  final List<String> _styleOptions = ['Casual', 'Formal', 'Sport', 'Elegant'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Style Preference',
          style: TextStyle(
            fontSize: widget.isTablet ? 15 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStyle,
          style: TextStyle(
            fontSize: widget.isTablet ? 16 : 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Select your style',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppConstants.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.isTablet ? 18 : 16,
            ),
          ),
          items: _styleOptions.map((String style) {
            return DropdownMenuItem<String>(
              value: style.toLowerCase(),
              child: Text(style),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStyle = newValue;
            });
            widget.onChanged(newValue);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your style preference';
            }
            return null;
          },
        ),
      ],
    );
  }
}