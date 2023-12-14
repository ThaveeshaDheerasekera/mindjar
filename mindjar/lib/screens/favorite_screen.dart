import 'package:flutter/material.dart';
import 'package:mindjar/repositories/notes_repository.dart';
import 'package:mindjar/widget/home_screen_widgets/note_widget.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesRepository>(
      builder: (context, ref, child) {
        return ref.getFavoriteNotes.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: ref.getFavoriteNotes.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: 15,
                        // Checking for the last item of the list
                        // adding padding (15) only to the last item on the list
                        bottom:
                            index != ref.getFavoriteNotes.length - 1 ? 0 : 15),
                    child: NoteWidget(note: ref.getFavoriteNotes[index]),
                  );
                },
              )
            : const Center(
                child: Text('Favorite list is empty...'),
              );
      },
    );
  }
}
