part of 'widgets.dart';

class CartListItem extends StatelessWidget {
  final CartItem cartItem;
  final String productId;

  CartListItem(this.cartItem, this.productId);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (dismisDirection) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Text(
                    "Are your sure?",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text("Do u want to remove item from the cart?",
                      style: TextStyle(color: Colors.white)),
                  actions: [
                    FlatButton(
                        splashColor: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "No",
                          style: GoogleFonts.lato(color: Colors.white),
                        )),
                    FlatButton(
                        splashColor: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text("Yes",
                            style: GoogleFonts.lato(color: Colors.white))),
                  ],
                ));
      },
      onDismissed: (dismisDirection) {
        Provider.of<Cart>(context, listen: false).deleteItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      child: Card(
        child: ListTile(
          leading: Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text("${cartItem.price}",
                  style: GoogleFonts.lato(color: Colors.white))),
          title: Text(cartItem.title,
              style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          subtitle: Text("Total: ${cartItem.price * cartItem.quantity}"),
          trailing: Text("x ${cartItem.quantity}"),
        ),
      ),
    );
  }
}
