class SongModel {
  String title;
  String artist;
  String? imageBase64;
  String path;
  String fallBackImage = 'assets/icon.png';

  SongModel({
    required this.title,
    required this.artist,
    required this.path,
    this.imageBase64,
  });

  factory SongModel.fromJson({
    Map<String, dynamic>? json,
    required String path,
  }) {
    SongModel s = SongModel(
      title: json?["Title"] ??
          path.substring(path.lastIndexOf('/') + 1, path.length - 4),
      artist: json?["Artist"] ?? "Unknown",
      path: path,
      imageBase64: json?["APIC"]?["base64"],
    );
    if (s.imageBase64?.trim() == '') s.imageBase64 = null;
    if (s.title.trim() == '') {
      s.title = path.substring(path.lastIndexOf('/') + 1, path.length - 4);
    }
    if (s.artist.trim() == '') s.artist = "Unknown";
    return s;
  }
}
