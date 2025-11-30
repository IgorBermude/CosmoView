class ImagemNasa {
  final String titulo;
  final String url;
  final String explanation;

  ImagemNasa({
    required this.titulo,
    required this.url,
    required this.explanation,
  });

  factory ImagemNasa.fromJson(Map<String, dynamic> json) {
    return ImagemNasa(
      titulo: json['title'] ?? json['titulo'] ?? '',
      url: json['url'] ?? '',
      explanation: json['explanation'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': titulo,
      'explanation': explanation
    };
  }
}
