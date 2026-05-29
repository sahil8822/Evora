import 'package:evora/features/vendor/domain/entities/vendor.dart';

abstract class VendorLocalDataSource {
  Future<List<Vendor>> getVendors();
}

class VendorLocalDataSourceImpl implements VendorLocalDataSource {
  // In a real app this could be a network call or local DB. Here we use a static list.
  @override
  Future<List<Vendor>> getVendors() async {
    return _initialVendors;
  }

  // Sample static vendor list (same as previously in VendorCubit)
  static final List<Vendor> _initialVendors = [
    // TODO: Populate with actual vendor data. Placeholder example:
    Vendor(
      id: '1',
      name: 'Sample Vendor',
      category: 'Tent House',
      price: '₹5000',
      rating: 4.5,
      distance: '2 km',
      imageUrl: 'https://example.com/vendor1.jpg',
      priceValue: 5000,
    ),
    // Add more vendors as needed
  ];
}
