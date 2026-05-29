import 'package:evora/cubit/vendor_cubit.dart';

abstract class VendorRepository {
  Future<List<Vendor>> getVendors();
}
