class StoryItem {
  String id;
  final String imageUrl;
  final DateTime sharedOn;
  bool isSeen;

  StoryItem({
    required this.id,
    required this.imageUrl,
    required this.sharedOn,
    required this.isSeen,
  });

  @override
  String toString() {
    return 'id: $id, imageUrl: $imageUrl, sharedOn: $sharedOn';
  }

  StoryItem.fromJson(Map<String, dynamic> json, this.id)
      : imageUrl = json['imageUrl'],
        sharedOn = DateTime.parse(json['sharedOn']),
        isSeen = false;

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'sharedOn': sharedOn.toString(),
    };
  }
}
