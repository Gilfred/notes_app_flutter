import 'package:flutter/material.dart';
import 'add_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notes = [];
  List<String> filteredNotes = [];
  TextEditingController searchController = TextEditingController();
  
  get provider => null;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchNotes);
  }

  void _searchNotes() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes
          .where((note) => note.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes de Cours'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une note...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: filteredNotes.isEmpty
          ? const Center(child: Text('Aucune note trouvée'))
          : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredNotes[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        notes.remove(filteredNotes[index]);
                        _searchNotes(); // Mise à jour après suppression
                      });
                    },
                  ),
                  onTap: () {
                     provider.startEditing(index);// Fonctionnalité d'édition à ajouter ici
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
          if (newNote != null && newNote.isNotEmpty) {
            setState(() {
              notes.add(newNote);
              _searchNotes();
            });
          }
        },
      ),
    );
  }
}
