import 'dart:convert';

import 'package:evora/core/models/feed_post.dart';
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

  Future<void> clearAll() async {
    _posts.clear();
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
        vendorName: 'Royal Tent House',
        category: 'Tent House',
        location: 'Ahmedabad',
        caption: 'Stunning Rajwadi tent setup for a grand wedding ceremony 🎪✨',
        priceLabel: '₹40,000',
        imageUrl:
            'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
        vendorAvatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        rating: 4.8,
        likes: 234,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      FeedPost(
        id: 'seed_2',
        vendorName: 'Golden Catering',
        category: 'Catering',
        location: 'Mumbai',
        caption: 'Luxury buffet spread with 50+ dishes for your special day 🍽️',
        priceLabel: '₹1,50,000',
        imageUrl:
            'https://images.unsplash.com/photo-1555244162-803834f70033?w=800',
        vendorAvatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
        rating: 4.9,
        likes: 567,
        createdAt: now.subtract(const Duration(hours: 18)),
      ),
      FeedPost(
        id: 'seed_3',
        vendorName: 'DJ Beats India',
        category: 'DJ',
        location: 'Delhi',
        caption: 'Professional DJ setup with LED lights and premium sound 🎵',
        priceLabel: '₹25,000',
        imageUrl:
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
        vendorAvatarUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
        rating: 4.7,
        likes: 189,
        createdAt: now.subtract(const Duration(hours: 9)),
      ),
      FeedPost(
        id: 'seed_4',
        vendorName: 'Dream Photo Studio',
        category: 'Photography',
        location: 'Jaipur',
        caption: 'Cinematic wedding photography that tells your love story 📸',
        priceLabel: '₹60,000',
        imageUrl:
            'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=800',
        vendorAvatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
        rating: 5.0,
        likes: 412,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      FeedPost(
        id: 'seed_5',
        vendorName: 'Elite Wedding Garden',
        category: 'Garden',
        location: 'Udaipur',
        caption: 'Breathtaking palace lawns for a fairy-tale wedding 🌿',
        priceLabel: '₹2,00,000',
        imageUrl:
            'https://images.unsplash.com/photo-1546032996-6dfacbacbae0?w=800',
        vendorAvatarUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=200',
        rating: 4.9,
        likes: 678,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
    ];
  }
}

