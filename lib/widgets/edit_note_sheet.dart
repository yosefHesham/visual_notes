import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';
import 'package:visual_notes/helpers/visual_note_validator.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';
import 'package:visual_notes/utils/visual_note_field.dart';
import 'package:visual_notes/utils/visual_note_image.dart';
import 'package:visual_notes/visual_note_model.dart';

class EditNoteBottomSheet extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  EditNoteBottomSheet({
    Key? key,
    required this.visualNote,
  }) : super(key: key);

  final VisualNote visualNote;

  @override
  State<EditNoteBottomSheet> createState() => _EditNoteBottomSheetState();
}

class _EditNoteBottomSheetState extends State<EditNoteBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  File? image;

  void getImage(File img) {
    image = img;
  }

  late String _status;
  @override
  void didChangeDependencies() {
    _status = widget.visualNote.status;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sizer = SizeHelper(context);
    var _titleController = TextEditingController(text: widget.visualNote.title);

    var _descriptionController =
        TextEditingController(text: widget.visualNote.description);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VisualNoteImage(
              getImage,
              image: widget.visualNote.picture,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    VisualNoteField(
                      hintText: "Note title",
                      controller: _titleController,
                      validator: VisualNoteValidator("title").validate,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    VisualNoteField(
                      hintText: "Note description",
                      maxLines: 2,
                      controller: _descriptionController,
                      onSubmit: (_) async {
                        VisualNote note = VisualNote(
                            id: widget.visualNote.id,
                            dateCreated: widget.visualNote.dateCreated,
                            lastUpdated: DateTime.now().toIso8601String(),
                            title: _titleController.text,
                            picture: image ?? widget.visualNote.picture,
                            status: _status,
                            description: _descriptionController.text);
                        await confirmEdit(context, note);
                      },
                      validator: VisualNoteValidator("description").validate,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Note Status",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        elevation: 2,
                        onChanged: (value) {
                          setState(() {
                            _status = value as String;
                          });
                        },
                        value: _status,
                        items: const [
                          DropdownMenuItem(
                            value: "Open",
                            child: Text("Open"),
                          ),
                          DropdownMenuItem(
                            value: "Closed",
                            child: Text("Closed"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: sizer.width * .7,
                height: sizer.width * .1,
                child: ElevatedButton(
                  onPressed: () async {
                    VisualNote note = VisualNote(
                        lastUpdated: DateTime.now().toIso8601String(),
                        id: widget.visualNote.id,
                        dateCreated: widget.visualNote.dateCreated,
                        title: _titleController.text,
                        picture: image ?? widget.visualNote.picture,
                        status: _status,
                        description: _descriptionController.text);
                    await confirmEdit(context, note);
                  },
                  child: const Text(
                    "Confirm Edit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  confirmEdit(BuildContext context, VisualNote note) async {
    if (_formKey.currentState!.validate()) {
      await Provider.of<VisualNoteProvider>(context, listen: false)
          .editNote(note);
      Navigator.of(context).pop();
    }
  }
}
