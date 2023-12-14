import 'package:flutter/material.dart';
import 'package:mindjar/repositories/notes_repository.dart';
import 'package:mindjar/screens/manipulate_note_screen.dart';
import 'package:mindjar/widget/global_widgets/elevated_button_widget.dart';
import 'package:mindjar/widget/home_screen_widgets/note_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<NotesRepository>(context, listen: false).fetchNoteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<NotesRepository>(builder: (context, ref, child) {
          return ref.getNotes.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: ref.getNotes.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: 15,
                          // Checking for the last item of the list
                          // adding padding (15) only to the last item on the list
                          bottom: index != ref.getNotes.length - 1 ? 0 : 80),
                      child: NoteWidget(note: ref.getNotes[index]),
                    );
                  },
                )
              : const Center(
                  child: Text('No Entries yet...'),
                );
        }),
        // Position the 'Add Entry' button
        // on the bottom of the page
        Positioned(
          right: 0,
          left: 0,
          bottom: 15,
          child: ElevatedButtonWidget(
            width: double.infinity,
            height: 50,
            borderRadius: 2,
            onPressed: () {
              // Navigate to AddEntryScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManipulateNoteScreen(),
                ),
              );
            },
            child: const Text(
              'Add Note',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
