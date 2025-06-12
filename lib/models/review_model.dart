class Review {
  String id;
  DateTime createdAt;
  String user; 
  double rating;
  String comment;
  String mediaId;

  Review({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.rating,
    required this.comment,
    required this.mediaId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      mediaId: json['mediaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'user': user,
      'rating': rating,
      'comment': comment,
      'mediaId': mediaId,
    };
  }
}