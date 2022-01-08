import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/visual_db.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';
import 'package:visual_notes/screens/add_visual_note_screen.dart';
import 'package:visual_notes/screens/visual_notes_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VisualNoteProvider>(
      create: (context) => VisualNoteProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme(
            primary: Color(0xff4357AD),
            onPrimary: Colors.black,
            primaryVariant: Color(0xff48A9A6),
            background: Colors.red,
            onBackground: Colors.black,
            secondary: Color(0xffC1666B),
            onSecondary: Colors.white,
            secondaryVariant: Colors.deepOrange,
            error: Color(0xffBC4749),
            onError: Color(0xffBC4749),
            surface: Colors.white,
            onSurface: Colors.black,
            brightness: Brightness.light,
          ),
        ),
        home: const VisualNotesScreen(title: "your notes"),
        routes: {
          AddVisualNoteScreen.routeName: (_) => const AddVisualNoteScreen()
        },
      ),
    );
  }
}
