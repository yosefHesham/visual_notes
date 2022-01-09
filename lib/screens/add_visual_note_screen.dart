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
              // show different layouts based on orientation
              child: sizer.isLandscape
                  ? buildLandscape(sizer)
                  : buildPortrait(sizer),
            ),
          ),
        ),
      ),
    );
  }

  /// this is the landscape layout
  Widget buildLandscape(SizeHelper sizer) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: sizer.height * .6,
                child: VisualNoteImage(),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  buildForm(context),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Note Status",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  buildDropDownButton(),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: sizer.width * .4,
            height: sizer.height * .1,
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
    );
  }

  // portrait layout
  Column buildPortrait(SizeHelper sizer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        VisualNoteImage(),
        const SizedBox(
          height: 20,
        ),
        buildForm(context),
        Text(
          "Note Status",
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryVariant,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        buildDropDownButton(),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: sizer.width * .7,
            height: sizer.height * .065,
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
    );
  }

  Padding buildDropDownButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
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
            maxLines: 2,
            hintText: "Note description",
            controller: _descriptionController,
            onSubmit: (_) async {
              await addNote(context);
            },
            validator: VisualNoteValidator("description").validate,
          ),
        ],
      ),
    );
  }

  Future<void> addNote(BuildContext context) async {
    /// getting image which is cached into the VisualNoteProvider
    File? pickedImage =
        Provider.of<VisualNoteProvider>(context, listen: false).pickedImage;

    // forcing user to pick an image
    if (pickedImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please pick an image")));
      return;
    }
    if (_formKey.currentState!.validate()) {
      // thte actual adding
      await Provider.of<VisualNoteProvider>(context, listen: false).addNote(
        VisualNote(
            title: _titleController.text,
            picture: pickedImage,
            status: _status,
            dateCreated: DateTime.now().toIso8601String(),
            description: _descriptionController.text),
      );
      Navigator.of(context).pop();
    }
  }
}
