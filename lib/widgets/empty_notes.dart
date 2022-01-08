import 'package:flutter/material.dart';
import 'package:visual_notes/screens/add_visual_note_screen.dart';

class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
              'You dont have any viual note yet , click button below to add',
              textAlign: TextAlign.center),
          TextButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddVisualNoteScreen.routeName);
            },
            label: const Text("Add Visual Note"),
          ),
        ],
      ),
    );
  }
}
