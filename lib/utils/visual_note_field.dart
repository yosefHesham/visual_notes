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
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        onFieldSubmitted: onSubmit,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black),
            fillColor:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(.5)),
      ),
    );
  }
}
