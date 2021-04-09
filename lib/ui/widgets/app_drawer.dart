part of 'widgets.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: 80,
              child: Center(
                child: Text(
                  "Hello Cuk!",
                  style: GoogleFonts.lato(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text("Shop"),
              onTap: () {
                Get.offNamed(
                    '/'); // Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.card_travel),
              title: Text("Orders"),
              onTap: () {
                Get.offNamed(OrderPages
                    .routeName); // Navigator.of(context).pushReplacementNamed(OrderPages.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Manage Product"),
              onTap: () {
                Get.offNamed(UserProductPage
                    .routeName); // Navigator.of(context).pushReplacementNamed(UserProductPage.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
              onTap: () {
                Get.back(); // Navigator.of(context)
                Get.offNamed(
                    '/'); // Navigator.of(context).pushReplacementNamed('/');

                Provider.of<Auth>(context, listen: false).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
