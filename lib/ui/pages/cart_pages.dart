part of 'pages.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.lato(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        "\$${cart.totalCount}",
                        style: GoogleFonts.lato(color: Colors.white),
                      )),
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textColor: Theme.of(context).accentColor,
                      highlightColor: Colors.amber,
                      onPressed: cart.items.length <= 0
                          ? null
                          : () async {
                              await Provider.of<Order>(context, listen: false)
                                  .orderItem(cart.items.values.toList(),
                                      cart.totalCount);

                              cart.clear();
                            },
                      child: Text("Order Now",
                          style: GoogleFonts.lato(fontSize: 18)))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: cart.items.length,
              itemBuilder: (_, i) => CartListItem(
                  cart.items.values.toList()[i], cart.items.keys.toList()[i]),
            ),
          )
        ],
      ),
    );
  }
}
