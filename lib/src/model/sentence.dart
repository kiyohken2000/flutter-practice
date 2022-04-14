class Sentence {
  final int id;
  final String title;

  Sentence({
    required this.id,
    required this.title
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
        id: json['id'],
        title: json['title']);
  }
}
