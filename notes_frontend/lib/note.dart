import 'dart:convert';

class Note {
  int id;
  String note;

  Note({
    required this.id,
    required this.note,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      note: map['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': note,
    };
  }

  String toJson() => json.encode(toMap());
}
