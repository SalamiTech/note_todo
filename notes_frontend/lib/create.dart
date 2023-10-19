import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'note.dart';
import 'urls.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _controller = TextEditingController();

  void _createNote() async {
    if (_controller.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse(ApiUrls.createNote),
        body: {'body': _controller.text},
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Go back to the main page
      } else {
        print('Failed to create note with status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Note')),
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
              onPressed: _createNote,
              child: Text('Create'),
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
