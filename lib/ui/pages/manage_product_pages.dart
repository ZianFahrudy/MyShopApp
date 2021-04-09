part of 'pages.dart';

class UserProductPage extends StatelessWidget {
  static const routeName = '/manage-page';
  @override
  Widget build(BuildContext context) {
    Future<void> _refreshProduct() async {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts(true);
    }

    // final productData = Provider.of<ProductProvider>(context);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Your Product"),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Get.to(() => EditProductPage());
                })
          ],
        ),
        body: FutureBuilder(
          future: _refreshProduct(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _refreshProduct(),
                      child: Consumer<ProductProvider>(
                        builder: (ctx, productData, _) => ListView.builder(
                            itemCount: productData.product.length,
                            itemBuilder: (_, i) {
                              return Column(
                                children: [
                                  UserProductCard(
                                      productData.product[i].id,
                                      productData.product[i].imageURL,
                                      productData.product[i].title),
                                  Divider(),
                                ],
                              );
                            }),
                      ),
                    ),
        ));
  }
}
