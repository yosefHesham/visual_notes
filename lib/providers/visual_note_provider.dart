import 'dart:io';

import 'package:flutter/material.dart';
import 'package:visual_notes/helpers/visual_db.dart';
import 'package:visual_notes/visual_note_model.dart';

/// we want adding, deleting , updating take effect on the screen
/// thats why change notifer is here
/// there are many other different ways to do this though

class VisualNoteProvider extends ChangeNotifier {
  final _db = VisualDBHelper.dbInstance;

  // we will cach our notes in this list
  List<VisualNote> notes = [];

  // this variable will be used during the process of picking image (will store it temporalry)
  File? pickedImage;

  // called when the user picks an image for his visual note
  void cacheImage(File image) {
    pickedImage = image;
  }

  // called after adding,editing a visual note
  void _clearCachedImage() {
    pickedImage = null;
  }

  // getting all notes and notify widgets listening to this provider
  Future<void> getAllNotes() async {
    try {
      notes = await _db.getAllNotes();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // add a note and notify widget listening to this provider

  Future<void> addNote(VisualNote note) async {
    try {
      var newNote = await _db.insertNote(note);
      notes.add(newNote);

      //clearing image after adding is done
      _clearCachedImage();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // delete a note and notify widget listening to this provider

  Future<void> deleteNote(VisualNote visualNote) async {
    // implemnting safe delete

    try {
      notes.remove(visualNote);
      await _db.deleteNote(visualNote.id!);
    } catch (e) {
      // in case of any exception , the note will be back to the list
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

      // clearing image after editing is done
      _clearCachedImage();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
