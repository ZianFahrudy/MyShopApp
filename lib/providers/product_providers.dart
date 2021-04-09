part of 'providers.dart';

class ProductProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this.userId, this._product);
  List<Product> _product = [];

  // bool _showFavorites = false;

  List<Product> get product {
    return [..._product];
  }

  List<Product> get productFav {
    return _product.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchProducts([bool filterProdByUser = false]) async {
    final filterStringUrl =
        filterProdByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url =
        'https://nyotix-b6274.firebaseio.com/products.json?auth=$authToken&$filterStringUrl';

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      var urlUserFav =
          'https://nyotix-b6274.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final responseUserFav = await http.get(urlUserFav);

      var dataUserFav = jsonDecode(responseUserFav.body);
      // var data = jsonDecode(response.body) as Map<String, dynamic>;

      List<Product> products = [];

      data.forEach((prodId, productData) {
        products.add(Product(
            id: prodId,
            imageURL: productData['imageURL'],
            title: productData['title'],
            price: productData['price'],
            isFavorite:
                dataUserFav == null ? false : dataUserFav[prodId] ?? false,
            description: productData['description']));
      });

      _product = products;

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://nyotix-b6274.firebaseio.com/products.json?auth=$authToken";

    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageURL': product.imageURL,
            'creatorId': userId,
          }));

      final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          imageURL: product.imageURL,
          title: product.title,
          price: product.price,
          description: product.description);

      _product.add(newProduct);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _product.indexWhere((element) => element.id == id);

    var url =
        "https://nyotix-b6274.firebaseio.com/products/$id.json?auth=$authToken";

    try {
      await http.patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageURL': newProduct.imageURL
          }));
    } catch (e) {
      throw e;
    }

    if (prodIndex >= 0) {
      _product[prodIndex] = newProduct;

      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://nyotix-b6274.firebaseio.com/products/$id.json?auth=$authToken";
    final existingProdIndex =
        _product.indexWhere((element) => element.id == id);
    var existingProduct = _product[existingProdIndex];

    _product.removeAt(existingProdIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _product.insert(existingProdIndex, existingProduct);
      notifyListeners();
      throw HttpExceptionz('Could not delete products');
    }

    existingProduct = null; // optional
  }

  Product findById(String id) {
    return _product.firstWhere((element) => element.id == id);
  }
}
