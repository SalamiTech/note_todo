import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'note.dart';
import 'urls.dart';
import 'create.dart';
import 'update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Django Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final http.Client client = http.Client();
  final List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _retrieveNotes();
  }

  Future<void> _retrieveNotes() async {
    try {
      final response = await client.get(Uri.parse(ApiUrls.getNotes));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);
        notes.clear();
        notes.addAll(responseBody.map((noteMap) => Note.fromMap(noteMap)));
        setState(() {});
      } else {
        print('Failed to load notes with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _deleteNote(int id) async {
    final response =
        await client.delete(Uri.parse(ApiUrls.deleteNote(id.toString())));
    if (response.statusCode == 200) {
      _retrieveNotes();
    } else {
      print('Failed to delete note with status code: ${response.statusCode}');
    }
  }

  void _addNote() {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => CreatePage(),
        ))
        .then((_) => _retrieveNotes()); // Refresh notes after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(notes[index].note),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteNote(notes[index].id),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => UpdatePage(note: notes[index]),
                  ))
                  .then(
                      (_) => _retrieveNotes()); // Refresh notes after updating
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
