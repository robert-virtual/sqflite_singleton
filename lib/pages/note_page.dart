import 'package:flutter/material.dart';
import 'package:sqflite_singleton/db.dart';
import 'package:sqflite_singleton/models/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, this.note}) : super(key: key);
  final Note? note;
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final title = TextEditingController();
  final content = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      title.text = widget.note!.title;
      content.text = widget.note!.content ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: title,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Titulo",
              hintStyle: TextStyle(color: Colors.white70)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.note != null) {
                  updateNote();
                } else {
                  saveNote();
                }
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: content,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Contenido",
          ),
        ),
      ),
    );
  }

  void saveNote() async {
    if (title.text.isNotEmpty) {
      final id =
          await DB.createNote(Note(title: title.text, content: content.text));
      showSnackBar("Nota guardada. id: $id");
    } else {
      showSnackBar("Titulo de la nota vacio");
    }
  }

  void updateNote() async{
    if (title.text.isNotEmpty) {
      await DB.updateNote(Note(id: widget.note!.id,title: title.text, content: content.text,date: DateTime.now()));
      showSnackBar("Nota actualizada.");
    } else {
      showSnackBar("Titulo de la nota vacio");
    }

  }

  void showSnackBar(String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
