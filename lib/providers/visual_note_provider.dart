import 'package:flutter/material.dart';
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

  Future<void> deleteNote(VisualNote visualNote) async {
    try {
      notes.remove(visualNote);
      await _db.deleteNote(visualNote.id!);
    } catch (e) {
      int noteIndex = notes.indexOf(visualNote);
      notes.insert(noteIndex, visualNote);
      rethrow;
    }
    notifyListeners();
  }

  Future<void> editNote(VisualNote visualNote) async {
    try {
      int indx = notes.indexWhere((element) => element.id == visualNote.id);
      notes[indx] = visualNote;
      await _db.updateNote(visualNote);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
