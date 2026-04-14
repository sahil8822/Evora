class FeedPost {
  final String id;
  final String vendorName;
  final String category;
  final String location;
  final String caption;
  final String priceLabel;
  final String imageUrl;
  final String vendorAvatarUrl;
  final double rating;
  final int likes;
  final DateTime createdAt;

  const FeedPost({
    required this.id,
    required this.vendorName,
    required this.category,
    required this.location,
    required this.caption,
    required this.priceLabel,
    required this.imageUrl,
    required this.vendorAvatarUrl,
    required this.rating,
    required this.likes,
    required this.createdAt,
  });

  FeedPost copyWith({
    String? id,
    String? vendorName,
    String? category,
    String? location,
    String? caption,
    String? priceLabel,
    String? imageUrl,
    String? vendorAvatarUrl,
    double? rating,
    int? likes,
    DateTime? createdAt,
  }) {
    return FeedPost(
      id: id ?? this.id,
      vendorName: vendorName ?? this.vendorName,
      category: category ?? this.category,
      location: location ?? this.location,
      caption: caption ?? this.caption,
      priceLabel: priceLabel ?? this.priceLabel,
      imageUrl: imageUrl ?? this.imageUrl,
      vendorAvatarUrl: vendorAvatarUrl ?? this.vendorAvatarUrl,
      rating: rating ?? this.rating,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorName': vendorName,
      'category': category,
      'location': location,
      'caption': caption,
      'priceLabel': priceLabel,
      'imageUrl': imageUrl,
      'vendorAvatarUrl': vendorAvatarUrl,
      'rating': rating,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: (json['id'] as String?) ?? '',
      vendorName: (json['vendorName'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'All',
      location: (json['location'] as String?) ?? '',
      caption: (json['caption'] as String?) ?? '',
      priceLabel: (json['priceLabel'] as String?) ?? '',
      imageUrl: (json['imageUrl'] as String?) ?? '',
      vendorAvatarUrl: (json['vendorAvatarUrl'] as String?) ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.now(),
    );
  }
}

