import 'package:flutter/material.dart';
import 'add_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Pour le moment, on stocke les notes dans une liste simple
  List<String> notes = [];

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
                return ListTile(
                  title: Text(notes[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Suppression d'une note
                      setState(() {
                        notes.removeAt(index);
                      });
                    },
                  ),
                  onTap: () {
                    // Ici, on pourra ajouter la fonctionnalité d'édition
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navigation vers la page d'ajout de note
          final newNote = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );
          if (newNote != null && newNote.isNotEmpty) {
            setState(() {
              notes.add(newNote);
            });
          }
        },
      ),
    );
  }
}
