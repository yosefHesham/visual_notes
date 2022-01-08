import 'dart:io';

import 'package:visual_notes/helpers/visual_db.dart';

class VisualNote {
  late int? id;
  late String title;
  late File picture;
  late String description;
  String? dateCreated = DateTime.now().toIso8601String();
  late String? lastUpdated;
  late String status;

  VisualNote(
      {this.id,
      required this.title,
      required this.picture,
      required this.status,
      this.lastUpdated,
      this.dateCreated,
      required this.description});

  toMap() {
    return {
      columnTitle: title,
      columnStatus: status,
      columnDateCreated: dateCreated,
      columnDescription: description,
      columnPicture: picture.path,
      columnLastUpdated: lastUpdated
    };
  }

  VisualNote.fromMap(Map<String, dynamic> visualNoteMap) {
    id = visualNoteMap[columnId];
    title = visualNoteMap[columnTitle];
    description = visualNoteMap[columnDescription];
    picture = File(visualNoteMap[columnPicture]);
    status = visualNoteMap[columnStatus];
    dateCreated = visualNoteMap[columnDateCreated];
    lastUpdated = visualNoteMap[columnLastUpdated];
  }
}
