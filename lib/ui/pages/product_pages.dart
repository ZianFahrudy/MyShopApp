part of 'pages.dart';

enum FilterOptions { favorites, showAll }

class ProductPages extends StatefulWidget {
  static const routeName = '/product-pages';
  @override
  _ProductPagesState createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  bool showFav = false;
  bool isInit = true;
  bool isLoading = false;

  // @override
  // void initState() {
  //   Provider.of<ThemeProvider>(context, listen: false).changeTheme(
  //       ThemeData(primarySwatch: Colors.purple, accentColor: Colors.white));
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() async {

  //   // final token = Provider.of<Auth>(context).token;
  //   if (isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<ProductProvider>(context).fetchProducts().then((value) {
  //       if (!mounted) return;
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // context.watch<ThemeProvider>().changeTheme(ThemeData(
    //     primarySwatch: Colors.purple, accentColor: Colors.deepOrange));
    //
    // setState(() {
    //   Provider.of<ThemeProvider>(context, listen: false).changeTheme(
    //       ThemeData(primarySwatch: Colors.purple, accentColor: Colors.white));
    // });

    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.favorites) {
                      showFav = true;
                    } else {
                      showFav = false;
                    }
                  });
                },
                itemBuilder: (ctx) => [
                      PopupMenuItem(
                        child: Text("Favorites"),
                        value: FilterOptions.favorites,
                      ),
                      PopupMenuItem(
                        child: Text("All"),
                        value: FilterOptions.showAll,
                      )
                    ]),
            Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                    child: IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          // Get.to(() => CartPage());
                          Get.toNamed(CartPage.routeName);
                        }),
                    value: cart.itemCount.toString())),
          ],
          title: Text("MyShop"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<ProductProvider>(context, listen: false)
                .fetchProducts(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : GridProduct(showFav)));
  }
}
