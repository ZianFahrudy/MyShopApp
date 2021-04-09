part of 'pages.dart';

class OrderPages extends StatefulWidget {
  static const routeName = '/order-page';
  @override
  _OrderPagesState createState() => _OrderPagesState();
}

class _OrderPagesState extends State<OrderPages> {
  // bool _isLoading = false;

  // @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   Future.delayed(Duration.zero).then((value) async {
  //     await Provider.of<Order>(context, listen: false)
  //         .fetchOrderData()
  //         .then((value) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   });
  // }

  //   super.initState();
  // }
  //
  // Future<void> getOrder(String token) async {
  //   var url = "https://nyotix-b6274.firebaseio.com/orders.json?auth=$token";
  //   final response = await http.get(url);

  //   // List<OrderItem> orderItem = [];

  //   // var jsonData = (jsonDecode(response.body) as Map<String, dynamic>);

  //   // jsonData.forEach((key, value) {
  //   //   orderItem.add(OrderItem(
  //   //       id: value['id'],
  //   //       product: (value['products'] as List<dynamic>).map((e) =>
  //   //           CartItem(id: e['id'], price: null, quantity: null, title: null)),
  //   //       amount: value['amount'],
  //   //       dateTime: value['dateTime']));
  //   // });

  //   print(jsonDecode(response.body));
  //   print('ttttt');
  // }

  // Future<void> getOrder(String token) async {
  //   await Provider.of<Order>(context, listen: false).fetchOrderData(token);
  // }

  // @override
  // void didChangeDependencies() {
  //   Provider.of<Order>(context).fetchOrderData();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final authToken = Provider.of<Auth>(context).token;
    // final ordersData = Provider.of<Order>(context);
    Future<void> _fetchDataorder() async {
      await Provider.of<Order>(context, listen: false).fetchOrderData();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _fetchDataorder(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                return Center(child: Text('An occured error'));
              } else {
                return Consumer<Order>(
                  builder: (ctx, ordersData, _) => ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (_, i) =>
                          OrderItemCard(ordersData.orders[i])),
                );
              }
            }));
  }
}
