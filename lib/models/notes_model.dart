import 'package:hive_flutter/hive_flutter.dart';
part 'notes_model.g.dart';   // g = generated

@HiveType(typeId: 0)
class NotesModel extends HiveObject {   // Notes ku HiveObject se extends krege to wo data lu automatically save krleta he, listen karleta he everything and UI Automatically Update hojati he. run this command: flutter packages pub run build_runner build, ye extra code auto. add kardega
  
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  NotesModel({
    required this.title, required this.description
  });
}
