import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindjar/configs/custom_colors.dart';
import 'package:mindjar/entities/note.dart';
import 'package:mindjar/repositories/notes_repository.dart';
import 'package:mindjar/widget/global_widgets/elevated_button_widget.dart';
import 'package:mindjar/widget/global_widgets/text_field_widget.dart';
import 'package:mindjar/widget/global_widgets/title_widget.dart';
import 'package:provider/provider.dart';

class ManipulateNoteScreen extends StatefulWidget {
  final Note? note;

  const ManipulateNoteScreen({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<ManipulateNoteScreen> createState() => _ManipulateNoteScreenState();
}

class _ManipulateNoteScreenState extends State<ManipulateNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? image;

  void onSubmit() {
    final model = Provider.of<NotesRepository>(context, listen: false);

    // Get the title text and content text
    final title = _titleController.text;
    final content = _contentController.text;

    // Check if either title or content is empty
    // If !empty --> proceed
    // If empty --> show error message saying title or content is missing
    if (title.isNotEmpty && content.isNotEmpty) {
      // If this screen is called without an Note object passed as a parameter,
      // Treats like a new note,
      // Otherwise get the existing values and display them and,
      // Update them if those values are updated
      if (widget.note == null) {
        model.createNote(title, content);
        // Navigate back after adding the note
        Navigator.pop(context);
        _showSnackBar(context, 'New note added successfully.');
      } else {
        // If an existing note is being updated...
        model.updateNote(
          noteId: widget.note!.noteId,
          title: _titleController.text,
          content: _contentController.text,
        );
        // model.updateEntry(widget.note!.note_id, title, content);
        // Navigate back after adding/updating the entry
        Navigator.pop(context);
        _showSnackBar(context,
            '[ Note ID: ${widget.note!.noteId} ] Updated successfully.');
      }
    } else {
      _showSnackBar(context, 'Title and content are required.');
    }
  }

  // // Image picker functionality
  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     _showSnackBar(context, 'Failed to pick image: $e');
  //   }
  // }
  //
  // // Function to clear the image
  // void clearImage() {
  //   print('clear');
  //   setState(() {
  //     image = null;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _titleController.text = '';
    _contentController.text = '';
    // Used for the update method
    // Check if an Entry object is passed
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.note == null
                ? 'Add Note'
                : DateFormat('dd-MMM-yyyy | HH:mm:ss')
                    .format(widget.note!.createdAt),
            style: const TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: CustomColors.olive,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Colors.black87,
            ),
          ),
          actions: [
            IconButton(
              onPressed: onSubmit,
              icon: const Icon(
                Icons.done,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: CustomColors.background,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  TitleWidget(
                    title: 'Title',
                    actions: [
                      ElevatedButtonWidget(
                        width: 50,
                        height: 30,
                        borderRadius: 2,
                        onPressed: () => _showModalBottomSheet(
                          context,
                          onPressed: () {
                            _titleController.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                    child: TextFieldWidget(
                      maxLength: 50,
                      hintText: 'Title',
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TitleWidget(
                    title: 'Content',
                    actions: [
                      ElevatedButtonWidget(
                        width: 50,
                        height: 30,
                        borderRadius: 2,
                        onPressed: () => _showModalBottomSheet(
                          context,
                          onPressed: () {
                            _contentController.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                    child: TextFieldWidget(
                      maxLines: 20,
                      hintText: 'Type...',
                      controller: _contentController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context,
      {required VoidCallback onPressed}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Are you sure?'),
              Row(
                children: [
                  TextButton(
                    onPressed: onPressed,
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    autofocus: true,
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// -------------------------

// -- This is the add image method --
// const SizedBox(height: 15),
// FormItemWidget(
// title: 'Add a photo',
// onPressed: () => clearImage(),
// child: Column(
// children: [
// Container(
// height: 200,
// decoration: BoxDecoration(
// border:
// Border.all(width: 1, color: Colors.grey),
// borderRadius: BorderRadius.circular(2),
// ),
// child: image != null
// ? Image.file(image!, fit: BoxFit.scaleDown)
//     : Center(
// child: Text(
// widget.entry?.image != null
// ? 'Choose a new image from your\ngallery or take a photo.\nYou can leave it blank\nif you do not wish to\nupdate the current photo.'
//     : 'Choose an image from your\ngallery or take a photo.\nYou can leave it blank.',
// textAlign: TextAlign.center,
// ),
// ),
// ),
// const SizedBox(height: 15),
// ElevatedButtonWidget(
// child: Text('Gallery'),
// width: 150,
// height: 35,
// borderRadius: 2,
// onPressed: () => pickImage(ImageSource.gallery),
// ),
// ElevatedButtonWidget(
// child: Text('Camera'),
// width: 150,
// height: 35,
// borderRadius: 2,
// onPressed: () => pickImage(ImageSource.camera),
// ),
// ],
// ),
// ),
// ----
