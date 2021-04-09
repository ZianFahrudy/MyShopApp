part of 'pages.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  static const routeName = '/product-details';

  ProductDetailsPage(this.product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: product.id,
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(product.imageURL),
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text(product.title,
                    style: GoogleFonts.lato()
                        .copyWith(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 10, right: 24),
                child: Text(
                    NumberFormat.currency(
                            locale: "id-ID", symbol: "IDR ", decimalDigits: 0)
                        .format(product.price),
                    style: GoogleFonts.lato().copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple)),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text("Description: ",
                    style: GoogleFonts.lato()
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text(product.description,
                    style: GoogleFonts.lato()
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
