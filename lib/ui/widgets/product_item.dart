part of 'widgets.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context);

    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
            child: GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetailsPage(products));
                },
                child: Hero(
                  tag: products.id,
                                  child: FadeInImage(
                    placeholder: AssetImage('assets/product-placeholder.png'),
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      products.imageURL,
                    ),
                  ),
                )),
            footer: GridTileBar(
              title: Text(
                products.title,
                style: GoogleFonts.lato().copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              leading: Consumer<Product>(
                builder: (ctx, productz, child) => IconButton(
                    icon: productz.isFavorite
                        ? Icon(
                            Icons.favorite,
                            color: Theme.of(context).accentColor,
                          )
                        : Icon(Icons.favorite_border),
                    onPressed: () {
                      products.toggleFavorite(auth.token, auth.userId);
                    }),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    cart.addItem(products.id, products.title, products.price);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text("Add item to cart"),
                          action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cart.deleteSingleItem(products.id);
                              })),
                    );
                  }),
              backgroundColor: Colors.black54,
            )),
      ),
    );
  }
}
