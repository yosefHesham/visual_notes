import 'package:flutter/material.dart';

class VisualNoteField extends StatelessWidget {
  VisualNoteField(
      {required this.hintText,
      required this.controller,
      required this.validator,
      this.onSubmit,
      Key? key})
      : super(key: key);
  String hintText;
  TextEditingController controller;

  void Function(String)? onSubmit;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          filled: true,
          hintText: hintText,
          fillColor: Theme.of(context).colorScheme.secondary),
    );
  }
}
