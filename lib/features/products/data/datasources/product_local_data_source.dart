import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

/// Static / local product data (no backend).
///
/// Images are loaded from picsum.photos (needs internet). If an image can't
/// load, the UI shows a placeholder icon instead of crashing.
/// To work fully offline, add images under `assets/images/` and point
/// `imageUrl` to them (see README).
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static String _img(String seed) =>
      'https://picsum.photos/seed/$seed/500/500';

  late final List<Map<String, dynamic>> _data = [
    {
      'id': 'p1',
      'name': 'Classic White Tee',
      'description': 'Soft 100% cotton crew-neck t-shirt for everyday wear.',
      'price': 499.0,
      'imageUrl': _img('white-tee'),
    },
    {
      'id': 'p2',
      'name': 'Slim Fit Denim Jeans',
      'description': 'Stretchable mid-rise jeans with a modern tapered fit.',
      'price': 1799.0,
      'imageUrl': _img('denim-jeans'),
    },
    {
      'id': 'p3',
      'name': 'Hooded Sweatshirt',
      'description': 'Warm fleece-lined hoodie with a roomy front pocket.',
      'price': 1299.0,
      'imageUrl': _img('hoodie'),
    },
    {
      'id': 'p4',
      'name': 'Running Sneakers',
      'description': 'Lightweight breathable sneakers with cushioned sole.',
      'price': 2499.0,
      'imageUrl': _img('sneakers'),
    },
    {
      'id': 'p5',
      'name': 'Leather Wallet',
      'description': 'Genuine leather bi-fold wallet with 6 card slots.',
      'price': 799.0,
      'imageUrl': _img('wallet'),
    },
    {
      'id': 'p6',
      'name': 'Aviator Sunglasses',
      'description': 'UV400 protected metal-frame sunglasses.',
      'price': 999.0,
      'imageUrl': _img('sunglasses'),
    },
    {
      'id': 'p7',
      'name': 'Casual Check Shirt',
      'description': 'Full-sleeve cotton shirt, perfect for weekends.',
      'price': 1199.0,
      'imageUrl': _img('check-shirt'),
    },
    {
      'id': 'p8',
      'name': 'Canvas Backpack',
      'description': 'Water-resistant 20L backpack with laptop sleeve.',
      'price': 1599.0,
      'imageUrl': _img('backpack'),
    },
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _data.map(ProductModel.fromJson).toList();
  }
}
