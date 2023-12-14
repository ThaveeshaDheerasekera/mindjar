import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String noteId;
  final String title;
  final String content;
  final DateTime createdAt;
  bool isCollapsed;
  bool isFav;

  Note({
    required this.noteId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isCollapsed = false,
    this.isFav = false,
  });

  factory Note.fromJson(Map<String, dynamic> json, String documentId) {
    return Note(
      noteId: documentId,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isCollapsed: json['isCollapsed'],
      isFav: json['isFav'],
      createdAt: json['created_at'] != null
          ? (json['created_at'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'noteId': noteId,
        'title': title,
        'note': content,
        'isCollapsed': isCollapsed,
        'isFav': isFav,
        'created_at': createdAt,
      };
}
