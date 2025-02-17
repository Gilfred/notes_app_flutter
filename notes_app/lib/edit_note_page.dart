import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditNotePage extends StatefulWidget {
  final String? initialContent;
  final int? noteId;

  const EditNotePage({Key? key, this.initialContent, this.noteId}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    String content = _controller.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La note ne peut pas être vide !")),
      );
      return;
    }

    if (widget.noteId == null) {
      await DatabaseHelper.instance.createNote(content);
    } else {
      await DatabaseHelper.instance.updateNote(widget.noteId!, content);
    }

    Navigator.pop(context, content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(hintText: 'Écrivez votre note...'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
