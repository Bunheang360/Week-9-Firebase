class Song {
  final String title;
  final String artistId;
  final Duration duration;
  final Uri imageUrl;

  Song({
    required this.title,
    required this.artistId,
    required this.duration,
    required this.imageUrl
  });

  @override
  String toString() {
    return 'Song(title: $title, artistId: $artistId, duration: $duration, imageUrl: $imageUrl)';
  }
}
