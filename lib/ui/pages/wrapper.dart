part of 'pages.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => auth.isAuth
          ? ProductPages()
          : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? SplashPage()
                      : AuthPages2()),
    );
  }
}
