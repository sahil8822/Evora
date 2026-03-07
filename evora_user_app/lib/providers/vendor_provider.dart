import 'package:flutter/material.dart';

class Vendor {
  final String id;
  final String name;
  final String category;
  final String price;
  final double rating;
  final String distance;
  final String imageUrl;
  final double priceValue;

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.priceValue,
  });
}

class VendorProvider with ChangeNotifier {
  String _searchQuery = '';
  String _selectedCategoryFilter = 'All';
  String _mainCategory = 'All';
  RangeValues _priceRange = const RangeValues(1000, 500000);
  String _locationFilter = '';

  String get searchQuery => _searchQuery;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  RangeValues get priceRange => _priceRange;
  String get locationFilter => _locationFilter;

  final List<Vendor> _allVendors = [
    Vendor(
      id: '1',
      name: 'Grand Royal Tent House',
      category: 'Tent House',
      price: '₹15,000',
      rating: 4.8,
      distance: '1.2 km away',
      priceValue: 15000,
      imageUrl:
          'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=400',
    ),
    Vendor(
      id: '2',
      name: 'Elite Decor & Lighting',
      category: 'Lighting',
      price: '₹25,000',
      rating: 4.5,
      distance: '2.5 km away',
      priceValue: 25000,
      imageUrl:
          'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&q=80&w=400',
    ),
    Vendor(
      id: '3',
      name: 'Shree Ram Tent & Decorators',
      category: 'Tent House',
      price: '₹45,000',
      rating: 4.9,
      distance: '0.8 km away',
      priceValue: 45000,
      imageUrl:
          'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&q=80&w=400',
    ),
    Vendor(
      id: '4',
      name: 'Creative Blooms Florist',
      category: 'Decoration',
      price: '₹8,000',
      rating: 4.2,
      distance: '3.1 km away',
      priceValue: 8000,
      imageUrl:
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=400',
    ),
    Vendor(
      id: '5',
      name: 'Vibrant Sound & DJ',
      category: 'DJ',
      price: '₹12,000',
      rating: 4.7,
      distance: '1.5 km away',
      priceValue: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?auto=format&fit=crop&q=80&w=400',
    ),
    Vendor(
      id: '6',
      name: 'Saffron Catering Services',
      category: 'Catering',
      price: '₹85,000',
      rating: 4.6,
      distance: '4.2 km away',
      priceValue: 85000,
      imageUrl:
          'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&q=80&w=400',
    ),
    Vendor(
      id: '7',
      name: 'Snapshot Pro Photos',
      category: 'Photography',
      price: '₹35,000',
      rating: 4.4,
      distance: '2.0 km away',
      priceValue: 35000,
      imageUrl:
          'https://images.unsplash.com/photo-1519225421980-715cb0215aed?auto=format&fit=crop&q=80&w=400',
    ),
    Vendor(
      id: '8',
      name: 'Pink City Palace Garden',
      category: 'Venue',
      price: '₹2,50,000',
      rating: 4.9,
      distance: '5.5 km away',
      priceValue: 250000,
      imageUrl:
          'https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&q=80&w=400',
    ),
  ];

  List<Vendor> get filteredVendors {
    return _allVendors.where((vendor) {
      final matchesMain =
          _mainCategory == 'All' || vendor.category == _mainCategory;

      final matchesSearch =
          vendor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vendor.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSubCategory =
          _selectedCategoryFilter == 'All' ||
          vendor.name.contains(
            _selectedCategoryFilter,
          ) || // Sub-filters check name for dummy data
          vendor.category == _selectedCategoryFilter;

      final matchesPrice =
          vendor.priceValue >= _priceRange.start &&
          vendor.priceValue <= _priceRange.end;

      final matchesLocation =
          _locationFilter.isEmpty ||
          vendor.distance.toLowerCase().contains(_locationFilter.toLowerCase());

      return matchesMain &&
          matchesSearch &&
          matchesSubCategory &&
          matchesPrice &&
          matchesLocation;
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateCategoryFilter(String filter) {
    _selectedCategoryFilter = filter;
    notifyListeners();
  }

  void setMainCategory(String category) {
    _mainCategory = category;
    notifyListeners();
  }

  void updateFilters({RangeValues? priceRange, String? location}) {
    if (priceRange != null) _priceRange = priceRange;
    if (location != null) _locationFilter = location;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryFilter = 'All';
    _mainCategory = 'All';
    _priceRange = const RangeValues(1000, 500000);
    _locationFilter = '';
    notifyListeners();
  }
}
