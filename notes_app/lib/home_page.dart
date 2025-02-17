import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_note_page.dart';
import 'edit_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await DatabaseHelper.instance.readAllNotes();
    setState(() {
      notes = data;
    });
  }

  Future<void> _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes de Cours'),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('Aucune note pour le moment'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note['content']),
                  subtitle: Text("Créé le : ${note['createdAt']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteNote(note['id']);
                    },
                  ),
                  onTap: () async {
                    final updatedNote = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotePage(
                          initialContent: note['content'],
                          noteId: note['id'],
                        ),
                      ),
                    );
                    if (updatedNote != null) {
                      _loadNotes();
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );
          if (newNote != null) {
            await DatabaseHelper.instance.createNote(newNote);
            _loadNotes();
          }
        },
      ),
    );
  }
}
