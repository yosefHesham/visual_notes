import 'package:flutter/material.dart';
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
    final sizer = SizeHelper(context);
    return Scaffold(
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
                        itemBuilder: (ctx, i) => Container(
                          width: sizer.width,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Image.file(provider.notes[i].picture),
                              Column(
                                children: [
                                  Text(provider.notes[i].title),
                                  Text(provider.notes[i].description),
                                  Text(provider.notes[i].dateCreated),
                                ],
                              ),
                            ],
                          ),
                        ),
                        itemCount: provider.notes.length,
                      ),
                    )),
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
