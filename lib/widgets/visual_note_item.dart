import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';
import 'package:visual_notes/visual_note_model.dart';

class VisualNoteItem extends StatelessWidget {
  const VisualNoteItem(
    this.visualNote, {
    Key? key,
  }) : super(key: key);

  final VisualNote visualNote;

  @override
  Widget build(BuildContext context) {
    final sizer = SizeHelper(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        onDismissed: (_) {
          Provider.of<VisualNoteProvider>(context, listen: false)
              .deleteNote(visualNote);
        },
        key: UniqueKey(),
        child: Container(
          width: sizer.width,
          height: sizer.height * .25,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(.5, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.file(
                  visualNote.picture,
                  height: sizer.height * .25,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      visualNote.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      visualNote.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(DateFormat('y, d MMM, ')
                        .add_jm()
                        .format(DateTime.parse(visualNote.dateCreated))
                        .toString()),
                  ],
                ),
              ),
              SizedBox(
                height: sizer.height * .25,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                    child: Text(
                      visualNote.status,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: visualNote.status == "Open"
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.green),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}