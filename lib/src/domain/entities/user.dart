class User {
  final String id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  Set<String> likedPostIds;
  Set<String> seenStoryItemIds;
  Set<String> favoritedPostIds;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.likedPostIds,
    required this.seenStoryItemIds,
    required this.favoritedPostIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': displayName,
      'lastName': lastName,
      'phone': phoneNumber,
      'likedPostIds': likedPostIds,
      'favoritedPostIds': favoritedPostIds,
      'email': email,
    };
  }

  Map<String, dynamic> toJsonForMessage() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'id': id,
      'phone': phoneNumber,
      'email': email,
    };
  }

  User.fromJsonForMessage(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        phoneNumber = json['phone'],
        email = json['email'],
        favoritedPostIds = {},
        likedPostIds = {},
        seenStoryItemIds = {};

  User.fromJson(Map<String, dynamic> json, this.id)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        phoneNumber = json['phone'] as String?,
        email = json['email'] as String?,
        seenStoryItemIds = Set<String>.from(json['seenStoryItemIds'] ?? {}),
        likedPostIds = json['likedPostIds'] == null
            ? {}
            : Set<String>.from(json['likedPostIds']),
        favoritedPostIds = json['favoritedPostIds'] == null
            ? {}
            : Set<String>.from(json['favoritedPostIds']);

  String get displayName {
    return '$firstName $lastName';
  }
}
