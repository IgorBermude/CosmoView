class ImagemNasa {
  final String titulo;
  final String url;

  ImagemNasa({
    required this.titulo,
    required this.url
  });

  factory ImagemNasa.fromJson(Map<String, dynamic> json){
    return ImagemNasa(
        titulo: json['title'],
        url: json['url'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'url': url,
      'title': titulo,
    };
  }
}