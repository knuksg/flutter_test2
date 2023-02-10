class Ariticle {
  int id;
  String title;
  String content;

  Ariticle({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Ariticle.fromJason(Map<String, dynamic> json) {
    return Ariticle(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
  dynamic toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };
}
