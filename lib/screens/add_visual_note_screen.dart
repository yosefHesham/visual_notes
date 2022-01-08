import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';
import 'package:visual_notes/helpers/visual_note_validator.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';
import 'package:visual_notes/utils/visual_note_field.dart';
import 'package:visual_notes/utils/visual_note_image.dart';
import 'package:visual_notes/visual_note_model.dart';

class AddVisualNoteScreen extends StatefulWidget {
  static const routeName = "/add_note";
  const AddVisualNoteScreen({Key? key}) : super(key: key);

  @override
  _AddVisualNoteScreenState createState() => _AddVisualNoteScreenState();
}

class _AddVisualNoteScreenState extends State<AddVisualNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = "Open";
  File? image;

  void getImage(File img) {
    image = img;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final sizer = SizeHelper(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Add Visual Note",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: sizer.width,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VisualNoteImage(getImage),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        VisualNoteField(
                          hintText: "Note title",
                          controller: _titleController,
                          validator: VisualNoteValidator("title").validate,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        VisualNoteField(
                          maxLines: 2,
                          hintText: "Note description",
                          controller: _descriptionController,
                          onSubmit: (_) async {
                            await addNote(context);
                          },
                          validator:
                              VisualNoteValidator("description").validate,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Note Status",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
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
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: sizer.width * .7,
                      height: sizer.width * .1,
                      child: ElevatedButton(
                        onPressed: () async {
                          await addNote(context);
                        },
                        child: const Text(
                          "Add Note",
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
          ),
        ),
      ),
    );
  }

  Future<void> addNote(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await Provider.of<VisualNoteProvider>(context, listen: false).addNote(
        VisualNote(
            title: _titleController.text,
            picture: image!,
            status: _status,
            dateCreated: DateTime.now().toIso8601String(),
            description: _descriptionController.text),
      );
      Navigator.of(context).pop();
    }
  }
}
