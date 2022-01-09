import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';
import 'package:visual_notes/visual_note_model.dart';
import 'package:visual_notes/widgets/edit_note_sheet.dart';

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

      /// swipe to delete
      child: Dismissible(
        direction: DismissDirection.startToEnd,
        onDismissed: (_) async {
          // the actual delete happens here
          await deleteItem(context);
        },
        confirmDismiss: (_) async {
          // confirming delete after a swipe
          return await showConfirmDeleteDialog(context);
        },
        key: UniqueKey(),
        child: Container(
          width: sizer.width,
          height: sizer.isLandscape ? sizer.height * .5 : sizer.height * .25,
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
                child: InkWell(
                  onTap: () {
                    // click on the picture to view on full screen
                    showPictureInFullScreen(context);
                  },
                  child: Image.file(
                    visualNote.picture,
                    height: sizer.isLandscape
                        ? sizer.height * .5
                        : sizer.height * .25,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: buildVisualNoteDetails(context)),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) {
                            return EditNoteBottomSheet(visualNote: visualNote);
                          });
                    },
                    icon: const Icon(Icons.edit, color: Colors.pink),
                  ),
                  SizedBox(
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // click on image to view it on full screen
  void showPictureInFullScreen(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => Image.file(visualNote.picture)));
  }

  // show title, description, date created..etc
  Widget buildVisualNoteDetails(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        FittedBox(
          child: Text(
            visualNote.title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryVariant,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
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
          height: 5,
        ),
        Text(
          "Date Created: ",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          DateFormat('y, d MMM, ')
              .add_jm()
              .format(
                DateTime.parse(visualNote.dateCreated!),
              )
              .toString(),
        ),
        visualNote.lastUpdated == null
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last update",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    DateFormat('y, d MMM, ')
                        .add_jm()
                        .format(
                          DateTime.parse(visualNote.lastUpdated!),
                        )
                        .toString(),
                  ),
                ],
              ),
      ],
    );
  }

  Future<bool?> showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Confirm Removing ${visualNote.title} ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              )
            ],
          );
        },
        context: context);
  }

  // delete function
  Future<void> deleteItem(BuildContext context) async {
    await Provider.of<VisualNoteProvider>(context, listen: false)
        .deleteNote(visualNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${visualNote.title} is deleted"),
      ),
    );
  }
}
