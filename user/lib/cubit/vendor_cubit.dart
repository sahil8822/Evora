import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// State class representing the current filters and vendor list
class VendorState {
  final String searchQuery;
  final String selectedCategoryFilter;
  final String mainCategory;
  final RangeValues priceRange;
  final String locationFilter;
  final List<Vendor> allVendors;

  const VendorState({
    this.searchQuery = '',
    this.selectedCategoryFilter = 'All',
    this.mainCategory = 'All',
    this.priceRange = const RangeValues(1000, 500000),
    this.locationFilter = '',
    required this.allVendors,
  });

  List<Vendor> get filteredVendors {
    return allVendors.where((vendor) {
      final matchesMain = mainCategory == 'All' || vendor.category == mainCategory;
      final matchesSearch = vendor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          vendor.category.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesSubCategory = selectedCategoryFilter == 'All' ||
          vendor.name.contains(selectedCategoryFilter) ||
          vendor.category == selectedCategoryFilter;
      final matchesPrice = vendor.priceValue >= priceRange.start && vendor.priceValue <= priceRange.end;
      final matchesLocation = locationFilter.isEmpty || vendor.distance.toLowerCase().contains(locationFilter.toLowerCase());
      return matchesMain && matchesSearch && matchesSubCategory && matchesPrice && matchesLocation;
    }).toList();
  }

  VendorState copyWith({
    String? searchQuery,
    String? selectedCategoryFilter,
    String? mainCategory,
    RangeValues? priceRange,
    String? locationFilter,
    List<Vendor>? allVendors,
  }) {
    return VendorState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryFilter: selectedCategoryFilter ?? this.selectedCategoryFilter,
      mainCategory: mainCategory ?? this.mainCategory,
      priceRange: priceRange ?? this.priceRange,
      locationFilter: locationFilter ?? this.locationFilter,
      allVendors: allVendors ?? this.allVendors,
    );
  }
}

class VendorCubit extends Cubit<VendorState> {
  VendorCubit() : super(VendorState(allVendors: _initialVendors));

  // Static list of sample vendors (copied from the original provider)
  static final List<Vendor> _initialVendors = [
    // ... (same vendor list as before, omitted for brevity) ...
  ];

  void updateSearchQuery(String query) => emit(state.copyWith(searchQuery: query));
  void updateCategoryFilter(String filter) => emit(state.copyWith(selectedCategoryFilter: filter));
  void setMainCategory(String category) => emit(state.copyWith(mainCategory: category));
  void updateFilters({RangeValues? priceRange, String? location}) {
    emit(state.copyWith(
      priceRange: priceRange ?? state.priceRange,
      locationFilter: location ?? state.locationFilter,
    ));
  }

  void clearFilters() => emit(state.copyWith(
    searchQuery: '',
    selectedCategoryFilter: 'All',
    mainCategory: 'All',
    priceRange: const RangeValues(1000, 500000),
    locationFilter: '',
  ));
}

class Vendor {
  final String id;
  final String name;
  final String category;
  final String price;
  final double rating;
  final String distance;
  final String imageUrl;
  final double priceValue;

  const Vendor({
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
