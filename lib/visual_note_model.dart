import 'dart:io';

class VisualNote {
  int id;
  String title;
  File picture;
  String description;
  DateTime date;
  String status;

  VisualNote(
      {required this.id,
      required this.title,
      required this.picture,
      required this.date,
      required this.status,
      required this.description});
}
