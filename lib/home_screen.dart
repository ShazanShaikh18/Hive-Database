import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';  // Maintain krta he ke beckend pe ke konsa object modify hogya usse frontend me real time me show kra dega, ya delete hua wo show kara dega.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade100,
        centerTitle: true,
        title: const Text("Hive Database", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {

          // Here convert <Box<NotesModel>> the data into List form
          var data = box.values.toList().cast<NotesModel>();

          return ListView.builder(
            itemCount: box.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 100,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(data[index].title.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    delete(data[index]);
                                  },
                                  child: const Icon(Icons.delete, color: Colors.red,)),
                                
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    _editDialog(data[index], data[index].title, data[index].description);
                                  },
                                  child: const Icon(Icons.edit)),
                                
                              ],
                            ),
                            
                            Expanded(child: Text(data[index].description.toString(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                              maxLines: null,)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },);
        },),
      // body: Column(
      //   children: [
      //     FutureBuilder(
      //       future: Hive.openBox('shazan'),
      //       builder: (context, snapshot) {
      //         return Column(
      //           children: [
      //             ListTile(
      //               title: Text(snapshot.data!.get('name').toString()),
      //               subtitle: Text(snapshot.data!.get('age').toString()),
      //               trailing: IconButton(
      //                 onPressed: () {
      //                   // for get
      //                   // snapshot.data!.put('name', 'Shazan Abdul Vajid');

      //                   // for delete
      //                   snapshot.data!.delete('name');
      //                   snapshot.data!.put('age', 23);
      //                   setState(() {
                          
      //                   });
      //                 },
      //                 // icon: Icon(Icons.edit),
      //                 icon: const Icon(Icons.delete),
      //                 ),
      //             )
                  
      //             // Text(snapshot.data!.get('details').toString()),
      //           ],
      //         );
      //     },),

      //     FutureBuilder(
      //       future: Hive.openBox('name'),
      //       builder: (context, snapshot) {
      //         return Column(
      //           children: [
      //             ListTile(
      //               title: Text(snapshot.data!.get('instagram').toString()),
      //               // subtitle: Text(snapshot.data!.get('age').toString()),
      //             )
                  
      //             // Text(snapshot.data!.get('details').toString()),
      //           ],
      //         );
      //     },)
      //   ],
      // ),


      // This is for add new note
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          _showDialog();
          
          // var box = await Hive.openBox('shazan');

          // var box2 = await Hive.openBox('name');

          // box2.put('instagram', 'royal_shazan18');

          // box.put('name', 'Shazan shaikh');
          // box.put('age', 26);

          // box.put('details', {
          //   'pro' : 'developer',
          //   'royal' : 'asdf'
          // });

          // print(box.get('name'));
          // print(box.get('age'));
          // print(box.get('details')['pro']);

          // print(box2.get('instagram'));
        },
        child: const Icon(Icons.add),),
    );
  }


  // This is for delete specific note data.
  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }


  // This is for edit specific note data
  Future<void> _editDialog(NotesModel notesModel, String title, String description) async {

    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(
                    )
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(
                    )
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),

            TextButton(
              onPressed: () async {
                
                notesModel.title = titleController.text.toString();

                notesModel.description = descriptionController.text.toString();

                await notesModel.save();

                titleController.clear();
                descriptionController.clear();
                
                Navigator.pop(context);
              },
              child: const Text('Edit')),  
          ],
        );
      },);
  }


  // This is for add new data in notes.
  Future<void> _showDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(
                    )
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(
                    )
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),

            TextButton(
              onPressed: () {
                final data = NotesModel(title: titleController.text, description: descriptionController.text);

                final box = Boxes.getData();
                box.add(data);
                // Yaha Data Save tab hi hoga jab Notes_Model ku HiveObject se Extends karege, else iske against mujhe unique key khud maintain karni padti.
                // data.save();

                titleController.clear();
                descriptionController.clear();
                
                print(box);

                Navigator.pop(context);
              },
              child: const Text('Add')),  
          ],
        );
      },);
  }
}