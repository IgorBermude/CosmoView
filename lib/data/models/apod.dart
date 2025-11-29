class Apod {
  final String title;
  final String date;
  final String explanation;
  final String url;
  final String mediaType;

  Apod({
    required this.title,
    required this.date,
    required this.explanation,
    required this.url,
    required this.mediaType,
  });

  bool get isImage => mediaType.toLowerCase() == 'image';

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      explanation: json['explanation'] ?? '',
      url: json['url'] ?? '',
      mediaType: json['media_type'] ?? 'image',
    );
  }
}
