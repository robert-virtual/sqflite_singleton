import 'package:flutter/material.dart';
import 'package:sqflite_singleton/db.dart';
import 'package:sqflite_singleton/models/note.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_singleton/pages/note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Note>> notes;
  final formatter = DateFormat("EEEE, d MMMM y");
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  void refreshNotes() {
    notes = DB.findNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const NotePage()));
          setState(() => refreshNotes());
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Note>>(
          future: notes,
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Aun No hay notas"),
                      Icon(Icons.auto_fix_normal)
                    ],
                  ),
                );
              }

              return GridView.count(
                crossAxisCount: 2,
                children: gridItems(snap.data!),
              );
            }
            if (snap.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Ups... ha ocurrido un error"),
                    Icon(Icons.warning)
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  List<Widget> gridItems(List<Note> notes) {
    return notes
        .map((e) => GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotePage(
                              note: e,
                            )));
                setState(() => refreshNotes());
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        e.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Flexible(child: Container(child: Text(e.content ?? "",overflow: TextOverflow.ellipsis,))),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, bottom: 11),
                        child: Text(e.content ?? ""),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() => deleteNote(e.id!));
                      },
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  void deleteNote(int id) {
    DB.deleteNote(id);
    refreshNotes();
  }
}


// return ListView.builder(
//                   itemCount: snap.data!.length,
//                   itemBuilder: (context, i) {
//                     return Column(
//                       children: [
//                         ListTile(
//                           title: Text(snap.data![i].title),
//                           subtitle: Text(formatter.format(snap.data![i].date)),
//                         ),
//                         const Divider()
//                       ],
//                     );
//                   });
