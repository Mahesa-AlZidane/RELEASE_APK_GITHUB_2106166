import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/note.dart';
import '../services/database_service.dart';
import 'fragments/custom_appbar.dart';
import 'fragments/note_card.dart';

class HomePage extends StatefulWidget {
  final DatabaseService dbService;
  const HomePage({super.key, required this.dbService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 139, 137, 43),
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 68, 255, 105), Color.fromARGB(255, 64, 255, 150)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FutureBuilder(
            future: widget.dbService.getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                return noteCardBuilder(snapshot.data!);
              } else {
                return const Center(child: Text("No Notes"));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/addnote');
          setState(() {});
        },
        label: const Text("Add Note"),
        icon: const Icon(Icons.note_add_rounded),
        backgroundColor: const Color.fromARGB(255, 64, 255, 153),
      ),
    );
  }

  Widget noteCardBuilder(List<Note> notes) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: NoteCard(
            note: notes[index],
            dbService: widget.dbService,
            onUpdateCallback: () => setState(() {}),
          ),
        );
      },
    );
  }
}
