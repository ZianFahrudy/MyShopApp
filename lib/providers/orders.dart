part of 'providers.dart';

class Order with ChangeNotifier {
  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._orders);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchOrderData() async {
    final url =
        "https://nyotix-b6274.firebaseio.com/orders/$userId.json?auth=$authToken";

    final response = await http.get(url);

    final List<OrderItem> loadedOrder = [];
    var orderJson = jsonDecode(response.body) as Map<String, dynamic>;

    if (orderJson == null) {
      return;
    }

    orderJson.forEach((orderId, orderData) {
      loadedOrder.add(OrderItem(
          id: orderId,
          product: (orderData['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  price: e['price'],
                  quantity: (e['quantity'] as num).toInt(),
                  title: e['title']))
              .toList(),
          amount: (orderData['amount'] as num).toInt(),
          dateTime: DateTime.parse(orderData['dateTime'])));
      
    });

    _orders = loadedOrder.reversed.toList();

    notifyListeners();
  }

  Future<void> orderItem(List<CartItem> cartProduct, int total) async {
    final url =
        "https://nyotix-b6274.firebaseio.com/orders/$userId.json?auth=$authToken";

    try {
      final response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': DateTime.now().toString(),
            'products': cartProduct
                .map((e) => {
                      'id': e.id,
                      'quantity': e.quantity,
                      'title': e.title,
                      'price': e.price
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
            id: jsonDecode(response.body)['name'],
            product: cartProduct,
            amount: total,
            dateTime: DateTime.now(),
          ));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}

class OrderItem {
  final String id;
  final List<CartItem> product;
  final int amount;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.product,
    @required this.amount,
    @required this.dateTime,
  });
}
