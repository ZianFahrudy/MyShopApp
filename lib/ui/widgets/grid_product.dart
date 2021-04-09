part of 'widgets.dart';

class GridProduct extends StatefulWidget {
  final bool showFav;
  GridProduct(this.showFav);
  @override
  _GridProductState createState() => _GridProductState();
}

class _GridProductState extends State<GridProduct> {
  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<ProductProvider>(context);
    // final listProduct = product.product;
    final productContainer =
        Provider.of<ProductProvider>(context, listen: false);
    final product =
        widget.showFav ? productContainer.productFav : productContainer.product;

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemCount: product.length,
        itemBuilder: (_, i) => ChangeNotifierProvider.value(
            value: product[i], child: ProductItem()));
  }
}
