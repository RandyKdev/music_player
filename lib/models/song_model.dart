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
    required Map<String, dynamic>? json,
    required String path,
  }) {
    return SongModel(
      title: json?["Title"] ??
          path.substring(path.lastIndexOf('/') + 1, path.length - 4),
      artist: json?["Artist"] ?? 'Unknown',
      path: path,
      imageBase64: json?["APIC"]?["base64"],
    );
  }
}
