import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';
import 'package:visual_notes/helpers/visual_note_validator.dart';
import 'package:visual_notes/utils/visual_note_field.dart';

class AddVisualNoteScreen extends StatefulWidget {
  static const routeName = "/add_note";
  const AddVisualNoteScreen({Key? key}) : super(key: key);

  @override
  _AddVisualNoteScreenState createState() => _AddVisualNoteScreenState();
}

final _titleController = TextEditingController();
final _descriptionController = TextEditingController();
String _status = "Open";
File? image;

class _AddVisualNoteScreenState extends State<AddVisualNoteScreen> {
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
                  Container(
                    height: sizer.height * .4,
                    width: sizer.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color:
                              Theme.of(context).colorScheme.secondaryVariant),
                    ),
                    child: image == null
                        ? chooseImageButton("Add Photo")
                        : Stack(
                            overflow: Overflow.visible,
                            children: [
                              Image.file(
                                image!,
                                fit: BoxFit.fill,
                                width: sizer.width,
                              ),
                              Positioned(
                                top: sizer.height * .36,
                                child: Container(
                                    color: Colors.white,
                                    child: chooseImageButton("Change Photo")),
                              )
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 20,
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
                    controller: _descriptionController,
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
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: sizer.width * .7,
                      height: sizer.width * .1,
                      child: ElevatedButton(
                        onPressed: () {},
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

  Center chooseImageButton(String title) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          chooseImage();
        },
        icon: const Icon(Icons.add_a_photo),
        label: Text(title),
      ),
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  Future<void> chooseImage() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Choose by"),
            actions: [
              TextButton(
                onPressed: () async {
                  _getFromCamera();
                },
                child: Text("Camera"),
              ),
              TextButton(
                onPressed: () async {
                  _getFromGallery();
                },
                child: Text("Gallery"),
              )
            ],
          );
        });
  }
}
