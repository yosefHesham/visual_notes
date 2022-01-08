/// this class is responsible for validating form fields

class VisualNoteValidator {
  String field;
  VisualNoteValidator(this.field);

  String? validate(String? value) {
    if (value!.isEmpty) {
      return "Please Enter $field";
    }
    return null;
  }
}
