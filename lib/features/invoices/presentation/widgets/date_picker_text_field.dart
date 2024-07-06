import 'package:flutter/material.dart';

class DatePickerTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  DatePickerTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) : firstDate = firstDate ?? DateTime(2024),  // Default first date
        lastDate = lastDate ?? DateTime(2050),    // Default last date
        super(key: key);

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        widget.controller.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: _pickDate,
    );
  }
}
