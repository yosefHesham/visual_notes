import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/visual_db.dart';
import 'package:visual_notes/visual_note_model.dart';

class VisualNoteProvider extends ChangeNotifier {
  final _db = VisualDBHelper.dbInstance;

  List<VisualNote> notes = [];

  Future<void> getAllNotes() async {
    try {
      notes = await _db.getAllNotes();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addNote(VisualNote note) async {
    try {
      var newNote = await _db.insertNote(note);
      notes.add(newNote);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}