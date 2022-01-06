import 'package:flutter/material.dart';

class AddVisualNoteScreen extends StatefulWidget {
  const AddVisualNoteScreen({Key? key}) : super(key: key);

  @override
  _AddVisualNoteScreenState createState() => _AddVisualNoteScreenState();
}

class _AddVisualNoteScreenState extends State<AddVisualNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Container()],
        ),
      ),
    );
  }
}
