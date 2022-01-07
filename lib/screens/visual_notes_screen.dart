import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';
import 'package:visual_notes/helpers/visual_db.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';
import 'package:visual_notes/screens/add_visual_note_screen.dart';
import 'package:visual_notes/visual_note_model.dart';

class VisualNotesScreen extends StatefulWidget {
  const VisualNotesScreen({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<VisualNotesScreen> createState() => _VisualNotesScreenState();
}

class _VisualNotesScreenState extends State<VisualNotesScreen> {
  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<VisualNoteProvider>(context, listen: false).getAllNotes();
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(AddVisualNoteScreen.routeName);
        },
        label: const Text("Add Visual Note"),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const LoadingIndicator()
          : Consumer<VisualNoteProvider>(
              builder: (context, provider, _) => provider.notes.isEmpty
                  ? const EmptyNotesWidget()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (ctx, i) =>
                            VisualNoteItem(provider.notes[i]),
                        itemCount: provider.notes.length,
                      ),
                    ),
            ),
    );
  }
}

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
    );
  }
}

class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You dont have any viual note yet , click button below to add',
          ),
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

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
