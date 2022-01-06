import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You dont have any viual note yet , click button below to add',
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {},
              label: const Text("Add Visual Note"),
            ),
          ],
        ),
      ),
    );
  }
}
