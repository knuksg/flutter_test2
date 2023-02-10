class MbtiQuestion {
  late String title;
  late List<String> candidates;
  late List<String> answers;

  MbtiQuestion({
    required this.title,
    required this.candidates,
    required this.answers,
  });

  MbtiQuestion.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        candidates = map['candidates'],
        answers = map['answers'];

  MbtiQuestion.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        candidates = json['body'].toString().split('/'),
        answers = json['answer'].toString().split('/');
}
