class PlaylistModel {
  final int? id;
  final String name;

  PlaylistModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'] as int?,
      name: map['name'] as String,
    );
  }
}
