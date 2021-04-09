part of 'providers.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageURL;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.imageURL,
      @required this.title,
      @required this.price,
      @required this.description,
      this.isFavorite = false});

  void setStatusFav(bool newValue) {
    isFavorite = newValue;

    notifyListeners();
  }

  Future<void> toggleFavorite(String authToken, String userId) async {
    bool currentStatus = isFavorite;
    final url =
        "https://nyotix-b6274.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken";

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: jsonEncode(isFavorite));

      if (response.statusCode >= 400) {
        setStatusFav(currentStatus);
      }
    } catch (e) {
      setStatusFav(currentStatus);
    }

    notifyListeners();
  }
}

List<Product> dummyProduct = [
  Product(
      id: "p1",
      title: "Red Tshirt",
      price: 89000,
      description:
          "Baju untuk bermain cocok bagi pria agar terlihat keren untuk bersatai dipantai",
      imageURL:
          "https://imgs.michaels.com/MAM/assets/1/726D45CA1C364650A39CD1B336F03305/img/91F89859AE004153A24E7852F8666F0F/10093625_r.jpg?fit=inside|1024:1024"),
  Product(
      id: "p2",
      title: "Adidas Y78",
      price: 159000,
      description:
          "Sepatu untuk jogging dilapangan dijalan bareng temen pacara dalan lain lain",
      imageURL:
          "https://photos6.spartoo.eu/photos/967/9670058/9670058_500_A.jpg"),
  Product(
      id: "p3",
      title: "Laptop Asus6767",
      price: 159000,
      description: "Laptop gaming reza arab oktovian gamaer jelek ganteng",
      imageURL:
          "https://www.itgaleri.com/wp-content/uploads/2019/07/Asus-ROG-Strix-G531GD.jpg"),
  Product(
      id: "p4",
      title: "Helm Begosasas",
      price: 320000,
      description: "Helm untuk melindungi kepala dari benturan",
      imageURL:
          "https://mk0hondacengkartgshx.kinstacdn.com/wp-content/uploads/2019/07/Honda-Fabulous-Helmet.jpg")
];
