import 'package:flutter/material.dart';
import 'package:hive_database/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  
  // This Two Lines add after run the command : flutter packages pub run build_runner build and after create notes_model.g.dart file created.
  Hive.registerAdapter(NotesModelAdapter());

  await Hive.openBox<NotesModel>('notes');  // open box

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}