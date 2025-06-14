import 'package:flutter/material.dart';

class FormFieldWidget extends StatelessWidget {
  final String label;

  const FormFieldWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
