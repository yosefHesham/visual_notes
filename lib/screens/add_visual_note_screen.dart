import 'package:flutter/material.dart';
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

class _AddVisualNoteScreenState extends State<AddVisualNoteScreen> {
  @override
  Widget build(BuildContext context) {
    final sizer = SizeHelper(context);
    return Scaffold(
      body: SizedBox(
        width: sizer.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondaryVariant),
                ),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text("add photo"),
                  ),
                ),
              ),
              VisualNoteField(
                hintText: "Note title",
                controller: _titleController,
                validator: VisualNoteValidator("title").validate,
              ),
              VisualNoteField(
                hintText: "Note description",
                controller: _titleController,
                validator: VisualNoteValidator("description").validate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
