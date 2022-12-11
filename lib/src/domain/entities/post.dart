class Post {
  String id;
  String imageUrl;
  String description;
  String publisher;
  String publisherId;
  String publisherLogoUrl;
  final DateTime publishedOn;
  num numberOfLikes;
  num numberOfComments;
  bool isLiked;
  bool isFavorited;

  @override
  String toString() {
    return 'id: $id, publisher: $publisher';
  }

  Post({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.publisher,
    required this.publisherId,
    required this.publisherLogoUrl,
    required this.publishedOn,
    this.numberOfLikes = 0,
    this.numberOfComments = 0,
    this.isLiked = false,
    this.isFavorited = false,
  });

  Post.fromJson(Map<String, dynamic> json, this.id)
      : imageUrl = json['imageUrl'],
        description = json['description'],
        publisher = json['publisher'],
        publisherLogoUrl = json['publisherLogoUrl'],
        publisherId = json['publisherId'],
        publishedOn = DateTime.parse(json['publishedOn']),
        numberOfLikes = json['numberOfLikes'],
        numberOfComments = json['numberOfComments'],
        isLiked = false,
        isFavorited = false;

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'description': description,
      'publisher': publisher,
      'publisherLogoUrl': publisherLogoUrl,
      'publisherId': publisherId,
      'publishedOn': publishedOn.toString(),
      'numberOfLikes': numberOfLikes,
      'numberOfComments': numberOfComments,
    };
  }

  Post copy() {
    return Post(
      id: id,
      imageUrl: imageUrl,
      description: description,
      publisher: publisher,
      publisherId: publisherId,
      publisherLogoUrl: publisherLogoUrl,
      publishedOn: publishedOn,
      isFavorited: isFavorited,
      isLiked: isLiked,
      numberOfComments: numberOfComments,
      numberOfLikes: numberOfLikes,
    );
  }
}
