import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/visual_db.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';
import 'package:visual_notes/screens/add_visual_note_screen.dart';
import 'package:visual_notes/widgets/empty_notes.dart';
import 'package:visual_notes/widgets/visual_note_item.dart';

class VisualNotesScreen extends StatefulWidget {
  const VisualNotesScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<VisualNotesScreen> createState() => _VisualNotesScreenState();
}

class _VisualNotesScreenState extends State<VisualNotesScreen> {
  @override
  void dispose() async {
    super.dispose();
    var db = await VisualDBHelper.dbInstance.database;
    await db.close();
  }

  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    // while fetching the notes, set loading to true to show indicator
    setState(() {
      isLoading = true;
    });

    // fetching notes from DB
    await Provider.of<VisualNoteProvider>(context, listen: false).getAllNotes();
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
