import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final List<T> options;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.getLabel,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DropdownButtonFormField<T>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
        ),
        items: options.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(getLabel(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
