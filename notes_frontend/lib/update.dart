import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'note.dart';
import 'urls.dart';

class UpdatePage extends StatefulWidget {
  final Note note;

  UpdatePage({required this.note});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.note.note;
  }

  void _updateNote() async {
    if (_controller.text.isNotEmpty) {
      final response = await http.put(
        Uri.parse(ApiUrls.updateNote(widget.note.id.toString())),
        body: {'body': _controller.text},
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Go back to the main page
      } else {
        print('Failed to update note with status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Note'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateNote,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
