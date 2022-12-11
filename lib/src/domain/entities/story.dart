import 'package:friend_zone/src/domain/entities/story_item.dart';

class Story {
  final String id;
  final List<StoryItem> items;
  String publisherLogoUrl;
  String publisherName;

  Story({
    required this.id,
    required this.items,
    required this.publisherLogoUrl,
    required this.publisherName,
  });

  bool get isAllSeen => items.every((StoryItem storyItem) => storyItem.isSeen);

  @override
  String toString() {
    return 'items: $items';
  }
}
