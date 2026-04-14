import 'dart:convert';

import 'package:evora_partner_app/core/models/feed_post.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedProvider extends ChangeNotifier {
  static const _storageKey = 'feed_posts_v1';

  final List<FeedPost> _posts = [];
  bool _initialized = false;

  List<FeedPost> get posts =>
      List.unmodifiable(_posts..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.trim().isEmpty) {
      _posts
        ..clear()
        ..addAll(_seedPosts());
      await _persist();
      notifyListeners();
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _posts
          ..clear()
          ..addAll(
            decoded.whereType<Map>().map((m) {
              return FeedPost.fromJson(Map<String, dynamic>.from(m));
            }),
          );
      }
    } catch (_) {
      _posts
        ..clear()
        ..addAll(_seedPosts());
      await _persist();
    }

    notifyListeners();
  }

  Future<void> addPost(FeedPost post) async {
    _posts.add(post);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_posts.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  List<FeedPost> _seedPosts() {
    final now = DateTime.now();
    return [
      FeedPost(
        id: 'seed_1',
        vendorName: 'Your Business',
        category: 'Decoration',
        location: 'Jaipur',
        caption: 'Welcome! Create your first post to get discovered.',
        priceLabel: '₹25,000',
        imageUrl:
            'https://images.unsplash.com/photo-1478146059778-26028b07395a?w=800',
        vendorAvatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
        rating: 4.8,
        likes: 12,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }
}

