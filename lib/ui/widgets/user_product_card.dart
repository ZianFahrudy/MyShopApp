part of 'widgets.dart';

class UserProductCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  UserProductCard(this.id, this.imageUrl, this.title);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 50,
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () {
                  // Navigator.of(context)
                  //     .pushNamed(EditProductPage.routeName, arguments: id);
                  Get.toNamed(EditProductPage.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).accentColor),
                onPressed: () async {
                  try {
                    await Provider.of<ProductProvider>(context, listen: false)
                        .deleteProduct(id);
                  } catch (e) {
                    Get.showSnackbar(GetBar(
                      duration: Duration(seconds: 2),
                      titleText: Text("Error"),
                      messageText: Text("Delete product failed!"),
                      backgroundColor: Colors.pink,
                    ));

                    // Scaffold.of(context)
                    //     .showSnackBar(SnackBar(content: Text(e)));
                  }
                })
          ],
        ),
      ),
    );
  }
}
