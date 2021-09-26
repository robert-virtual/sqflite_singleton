class Note {
  int? id;
  String title;
  String? content;
  DateTime date;

  Note({this.id, required this.title, this.content="hola",date}):date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "content": content, "date": date.toIso8601String()};
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      title: map["title"],
      content: map["content"],
      date: DateTime.parse(map["date"]) 
    );
  }
}
