class EcoLesson {
  final String title;
  final String description;
  final String videoUrl;

  EcoLesson({
    required this.title,
    required this.description,
    required this.videoUrl,
  });

  factory EcoLesson.fromMap(Map<String, dynamic> map) {
    return EcoLesson(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
    );
  }
}
