import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  void _addNote(String title, Timestamp creationDate, String content) async {
    try {
      if (title.trim().isEmpty || content.trim().isEmpty) {
        throw Exception('Title and content cannot be empty');
      }

      final random = Random();
      final colorId = random.nextInt(7) + 1;

      await FirebaseFirestore.instance.collection('notes').add({
        'title': title,
        'creationDate': creationDate,
        'content': content,
        'color_id': colorId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e, stackTrace) {
      print('Error saving note: $e');
      print('Stacktrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving note: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddNoteForm(
                onSubmit: _addNote,
              ),
            );
          },
          child: const Text('Add Note'),
        ),
      ),
    );
  }
}

class AddNoteForm extends StatefulWidget {
  final void Function(String, Timestamp, String) onSubmit;

  const AddNoteForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _AddNoteFormState createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
                labelStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
             TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Content here',
                labelStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                
              ),
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text.trim();
            final content = _contentController.text.trim();
            final creationDate = Timestamp.fromDate(DateTime.now());

            if (title.isNotEmpty && content.isNotEmpty) {
              widget.onSubmit(title, creationDate, content);
              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Title and content cannot be empty'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
